//
//  AutorizationViewController.m
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "SignInViewController.h"

#import "CJModel.h"
#import "NSString+CJString.h"

@import Parse;

@interface SignInViewController ()<
UITextFieldDelegate,
AFClientManagerDelegate>{
    UIAlertController *alertController;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

// The controller of the screen (SignInViewController)
@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////
- (void) resignAllFirstResponders{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)backClick:(id)sender {
    [self performSegueWithIdentifier:@"goLaunch" sender:self];
}

// The function which is derived by click the Submit button
- (IBAction)submitClick:(id)sender {
    Manager.delegate = self;
    [self resignAllFirstResponders];
    [[NSUserDefaults standardUserDefaults] setObject:[Model md5hash:_passwordTextField.text] forKey: @"password"];
    [Manager logIn:@{@"username" : self.emailTextField.text, @"password" : self.passwordTextField.text}];
}

// The function which is derived by click the Forgot password button
- (IBAction)forgetPasswordClick:(id)sender {
    alertController = [UIAlertController
                       alertControllerWithTitle: @"Please enter your e-mail to restore the password"
                       message: @""
                       preferredStyle:UIAlertControllerStyleAlert];
                       
    // Called when user clicks ok. Will send password to use in email. 
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Send"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         UITextField *tf = alertController.textFields.firstObject;
                                                         [tf resignFirstResponder];
                                                         
                                                         // prepare query
                                                         PFQuery *query = [PFUser query];
                                                         [query whereKey:@"email" equalTo:tf.text];
                                                         
                                                         // fetch result in background
                                                         [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
                                                             if (error) {
                                                                 // user not found meaning email is not registered
                                                                 [CJAllertManager presentAllertInController:self text:@"This email address is not registered" message:@"" block:^{
                                                                 }];
                                                                 return ;
                                                             }
                                                             
                                                             // user found, send email in background
                                                             [PFUser requestPasswordResetForEmailInBackground:tf.text block:^(BOOL succeeded, NSError *error) {
                                                                 if (error || !succeeded) {
                                                                     return ;
                                                                 }
                                                                 // show alert to use to check his email
                                                                 [CJAllertManager presentAllertInController:self
                                                                                                       text:@"Please check your e-mail for further instructions"
                                                                                                    message:@""
                                                                                                      block:^{}];
                                                             }];
                                                         }];
                                                     }];
    // called if user cancels the action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action){
                                                     }];
    [alertController addAction:OkAction];
    [alertController addAction:cancelAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////
#pragma mark - TextFields
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
    if ([requestName isEqualToString:M_LOGIN]) {
        if (error) {
            if ([((NSError *)results).userInfo[@"code"] longValue] == 101) {
                [CJAllertManager presentAllertInController:self
                                                      text:@"Email or password is incorrect"
                                                   message:@""
                                                     block:^{}];
            }else{
                [CJAllertManager presentAllertInController:self
                                                      text:error
                                                   message:@""
                                                     block:^{}];
            }
            return;
        }
        
        __block id person;
        // if user is doctor
        if (results[C_Doctor]) {
            person = results[C_Doctor];
        }else{// if user is parent
            person = results[C_Parent];
        }
        
        [person fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                NSLog(@"some error");
                return;
            }
            
            person = object;
            // if user is doctor
            if (results[C_Doctor]) {
                // check if doctor is not confirmed by admin yet
                if (![person[C_Confirmed] boolValue]) {
                    [CJAllertManager presentAllertInController:self
                                                          text:@"Your account is awaiting to be accepted by administrator"
                                                       message:@""
                                                         block:^{}];
                    return;
                }
                // set doctor as current user and forward to doctor section
                Model.user = PFUser.currentUser;
                [self performSegueWithIdentifier:@"goDoctorMain" sender:self];
            }else{      // if user is parent
                // set parent as current user and forward to parent section
                Model.user = PFUser.currentUser;
                [self performSegueWithIdentifier:@"goParentMain" sender:self];
            }
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
