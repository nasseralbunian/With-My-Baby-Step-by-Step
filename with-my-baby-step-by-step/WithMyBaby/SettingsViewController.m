//
//  SettingsViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "SettingsViewController.h"

#import "CJModel.h"

@interface SettingsViewController ()<
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwiper;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

// The controller of the screen (SettingsViewController)
@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////
- (void)resignAllFirstResponders{
    [_oldPasswordTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)aboutClick:(id)sender {
    [self performSegueWithIdentifier:@"goAbout" sender:self];
}


// The function which is derived by click the Send button
- (IBAction)sendClick:(id)sender {
    [self resignAllFirstResponders];
    
    // if old password is incorrect
    if (![[Model md5hash:_oldPasswordTextField.text] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]]) {
        [CJAllertManager presentAllertInController:self text:@"Password is incorrect" message:@"" block:^{
        }];
        return;
    }
    
    __block NSString *newPassword = _passwordTextField.text;
    
    // if new password is empty
    if (!newPassword.length) {
        [CJAllertManager presentAllertInController:self text:@"Password field is empty" message:@"" block:^{
        }];
        return;
    }
    
    // if new password and confirm passwords don't match
    if (![newPassword isEqualToString:_confirmPasswordTextField.text]) {
        [CJAllertManager presentAllertInController:self text:@"Passwords do not match" message:@"" block:^{
        }];
        return;
    }
    
    // set new password to current user
    PFUser *currentUser = [PFUser currentUser];
    currentUser.password = newPassword;
    
    __block NSString *username = currentUser.username;
    
    // save on server in the background
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // return if error
        if (error) {
            return ;
        }
        
        // log the user out
        [PFUser logOut];
        
        // set new password in defaults
        [[NSUserDefaults standardUserDefaults] setObject:[Model md5hash:newPassword] forKey: @"password"];
        
        // login with new password in background
        [PFUser logInWithUsernameInBackground:username password:newPassword block:^(PFUser * user, NSError * error) {
            // show alert for success
            [CJAllertManager presentAllertInController:self text:@"Your password has been chaged successfully" message:@"" block:^{
            }];
        }];
    }];
}

- (IBAction)switcherValueChanged:(id)sender {
}

////////////////////////////////////////////////////////////////////
#pragma mark - TextFieldDelegate
////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllFirstResponders];
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
