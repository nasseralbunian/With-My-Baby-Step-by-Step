//
//  ParentSignUpTableViewController.m
//  WithMyBaby
//
//  Created by Nasser on 19.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentSignUpTableViewController.h"
#import "NSString+CJString.h"

#import "CJModel.h"

@interface ParentSignUpTableViewController ()<
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

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

// The controller of the screen (ParentSignUpTableViewController)
@implementation ParentSignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaultDate = _datePicker.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_textView setContentOffset:CGPointZero animated:NO];
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
}

// The function clears all the text fields
- (void)clearAll{
    [self resignAllFirstResponders];
    _firstNameTextField.text = @"";
    _lastNameTextField.text = @"";
    _cityTextField.text = @"";
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
    _confirmedPasswordTextField.text = @"";
    _datePicker.date = defaultDate;
}

// The function which is derived by click the Submit button
- (void)submit{
    if (_switchButton.on == NO) {
        [CJAllertManager presentAllertInController:self text:@"Please accept you are agree with the application usage terms" message:@"" block:^{
        }];
        return;
    }
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
#pragma mark - textField Delegate
////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllFirstResponders];
    
    return YES;
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
        
        Parent *parent = [Parent object];
        
        parent.firstname = _firstNameTextField.text;
        parent.lastname = _lastNameTextField.text;
        parent.city = _cityTextField.text;
        parent.dob = _datePicker.date;
        parent.confirmed = NO;
        [parent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (!succeeded || error) {
                return;
            }
            
            PFUser *currentUser = [PFUser currentUser];
            [currentUser setValue:parent forKey:C_Parent];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (!succeeded || error) {
                    return;
                }
                
                [self performSegueWithIdentifier:@"goParentMain" sender:self];
            }];
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
