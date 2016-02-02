//
//  AddMyChildViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AddMyChildViewController.h"

#import "CJModel.h"

@interface AddMyChildViewController ()<UITextFieldDelegate>{
    BOOL gender;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

// The controller of the screen (AddMyChildViewController)
@implementation AddMyChildViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    // set tap recognizer
    UITapGestureRecognizer *gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleGestureRecognizerTap)];
    [self.view addGestureRecognizer: gestureRecognizerTap];
    
    [self resetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////

// The function resets the data of the visual elements
- (void)resetData{
    // if child always exists then we load his parameters, else set default values
    if (_child) {
        if (_child.gender) {
            [_genderButton setTitle:@"male" forState:UIControlStateNormal];
        }else{
            [_genderButton setTitle:@"female" forState:UIControlStateNormal];
        }
        gender = _child.gender;
        _nameTextField.text = _child.name;
        _datePicker.date = _child.dob;
        
    }else{
        gender = YES;
        [_genderButton setTitle:@"male" forState:UIControlStateNormal];
        _nameTextField.text = @"";
        _datePicker.date = [NSDate date];
    }
}

////////////////////////////////////////////////////////////////////
#pragma mark - Recognizers
////////////////////////////////////////////////////////////////////
-(void)handleGestureRecognizerTap{
    [_nameTextField resignFirstResponder];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)genderButtonClick:(id)sender {
    gender = !gender;
    if (gender) {
        [_genderButton setTitle:@"male" forState:UIControlStateNormal];
    }else{
        [_genderButton setTitle:@"female" forState:UIControlStateNormal];
    }
}

- (IBAction)clearButtonClick:(id)sender {
    [self resetData];
}

// The function which is derived by click the Submit button
- (IBAction)submitButtonClick:(id)sender {
    if (!_child) {
        _child = [Child object];
    }
    if (_nameTextField.text && _nameTextField.text.length > 0) {
        _child.parent = Model.parent;
        _child.name = _nameTextField.text;
        _child.gender = gender;
        _child.dob = _datePicker.date;
        _child.takenVaccines = @[];
        [_child saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [Model reloadChildren];
        }];
        
        [self performSegueWithIdentifier:@"goMyChild" sender:self];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"You must enter the child name"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

////////////////////////////////////////////////////////////////////
#pragma mark - TextField
////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_nameTextField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
