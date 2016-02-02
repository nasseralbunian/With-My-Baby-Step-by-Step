//
//  SignInViewController.m
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "SignUpViewController.h"

#import "CJModel.h"

@interface SignUpViewController ()

@end

// The controller of the screen (SignUpViewController)
@implementation SignUpViewController

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
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The action of Back button is go back to Laucnh screen
- (IBAction)backClick:(id)sender {
    [self performSegueWithIdentifier:@"goLaunch" sender:self];
}

// The action of Parent registration link is to go to Parent SignUp screen
- (IBAction)parentRegistrationClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentSignUp" sender:self];
}

// The action of Doctor registration link is to go to Doctor Signup screen
- (IBAction)doctorRegistrationClick:(id)sender {
    [self performSegueWithIdentifier:@"goDoctorSignUp" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)unwindForSignUp:(UIStoryboardSegue *)segue{
}


@end
