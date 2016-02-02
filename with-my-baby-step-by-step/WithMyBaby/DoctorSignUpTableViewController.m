//
//  DoctorSignUpTableViewController.m
//  WithMyBaby
//
//  Created by Nasser on 19.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorSignUpTableViewController.h"
#import "NSString+CJString.h"

#import "CJModel.h"

@interface DoctorSignUpTableViewController ()<
UIPickerViewDelegate, UIPickerViewDataSource,
AFClientManagerDelegate
>{
    NSDate *defaultDate;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@end

// The controller of the screen (DoctorSignUpTableViewController)
@implementation DoctorSignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaultDate = _datePicker.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////

// The function which removes the text cursor from the current text field
- (void) resignAllFirstResponders{
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_cityTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmedPasswordTextField resignFirstResponder];
    [_minTextField resignFirstResponder];
}

// The validation of the all text fields
- (NSString *) validateAllFields{
    NSString *result = nil;
    NSString *value = _emailTextField.text;
    if (!value.length || ![value isValidEmail]) {
        NSString *error = @"Wrong email address";
        result = result? [NSString stringWithFormat:@"%@\n%@", result, error] : error;
    }
    
    value = _passwordTextField.text;
    if (!value.length){
        NSString *error = @"Password field is empty";
        result = result? [NSString stringWithFormat:@"%@\n%@", result, error] : error;
    }
    
    if (_passwordTextField.text.length && ![_passwordTextField.text isEqualToString: _confirmedPasswordTextField.text]) {
        NSString *error = @"Passwords do not match";
        result = result? [NSString stringWithFormat:@"%@\n%@", result, error] : error;
    }
    
    return result;
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)backClick:(id)sender {
    [self performSegueWithIdentifier:@"goSignUp" sender:self];
}

// The function which is derived by click the Clear button
- (IBAction)clearClick:(id)sender {
    [self resignAllFirstResponders];
    
    _firstNameTextField.text = @"";
    _lastNameTextField.text = @"";
    _cityTextField.text = @"";
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
    _confirmedPasswordTextField.text = @"";
    
    _datePicker.date = defaultDate;
    [_pickerView selectRow:0 inComponent:0 animated:YES];
}

// The function which is derived by click the Submit button
- (IBAction)submitClick:(id)sender {
    [self resignAllFirstResponders];
    NSString *errorString = [self validateAllFields];
    if (errorString.length) {
        [CJAllertManager presentAllertInController:self
                                              text:@"Error!"
                                           message:errorString
                                             block:^{}];
        return;
    }
    
    Manager.delegate = self;
    
    NSMutableDictionary *usersParameters = [@{@"email" : _emailTextField.text,
                                              @"password" : _passwordTextField.text} mutableCopy];
    
    [Manager registrateNewUser:usersParameters];
}

////////////////////////////////////////////////////////////////////
#pragma mark - textField Delegate
////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllFirstResponders];
    
    return YES;
}

////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerView
////////////////////////////////////////////////////////////////////

// The function which is derived to manage the picker view cell design
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"HelveticaNeue" size:12.];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    tView.text = Model.specializations[row][@"name"];
    return tView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return Model.specializations.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

////////////////////////////////////////////////////////////////////
#pragma mark - ClientManager
////////////////////////////////////////////////////////////////////

// The function of the ClientManager protocol which is derived when the answer from the server is recieved
- (void)manager:(AFClientManager *)manager request:(NSString *)requestName error:(NSString *)error results:(id)results{
    if ([requestName isEqualToString:M_SIGNUP]) {
        if (error) {
            [CJAllertManager presentAllertInController:self
                                                  text:error
                                               message:@""
                                                 block:^{}];
            return;
        }
        
        Doctor *doctor = [Doctor object];
        
        doctor.firstname = _firstNameTextField.text;
        doctor.lastname = _lastNameTextField.text;
        doctor.city = _cityTextField.text;
        doctor.dob = _datePicker.date;
        doctor.min = _minTextField.text;
        doctor.speciality = Model.specializations[[_pickerView selectedRowInComponent:0]][@"name"];
        doctor.confirmed = NO;
        [doctor saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                return;
            }
            
            PFUser *currentUser = [PFUser currentUser];
            [currentUser setValue:doctor forKey:C_Doctor];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (!succeeded || error) {
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJAllertManager presentAllertInController:self
                                                          text:@"Complete! Your account is awaiting to be accepted by administrator"
                                                       message:@""
                                                         block:^{
                                                             [Manager logout];
                                                             [self performSegueWithIdentifier:@"goLaunch" sender:self];
                                                         }];
                });
            }];
        }];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
