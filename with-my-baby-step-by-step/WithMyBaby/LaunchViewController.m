//
//  LaunchViewController.m
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "LaunchViewController.h"

#import "CJModel.h"

@interface LaunchViewController ()

@end


// The controller of the screen (LaunchViewController)
@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The function is derived for the each visible screen
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // if currentUser exists then load next viewController (ParentMainVC or DoctorMainVC)
    if (PFUser.currentUser) {
        Model.user = PFUser.currentUser;
        // check if current user is doctor
        if (PFUser.currentUser[C_Doctor]) {
            __block Doctor *doctor = PFUser.currentUser[C_Doctor];
            [doctor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"some error");
                    return;
                }
                
                doctor = (Doctor *)object;
                // forward the doctor to its main view if it is confirmed
                if (doctor.confirmed) {
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorMainViewControllerID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }else{
            __block Parent *parent = PFUser.currentUser[C_Parent];
            [parent fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"some error");
                    return;
                }
                
                parent = (Parent *)object;
                
                // forward the parent to its main view if it is confirmed. parent will be confirmed upon registration by default 
                if (parent.confirmed) {
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ParentMainViewControllerID"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
}
////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)loginClick:(id)sender {
    [self performSegueWithIdentifier:@"goSignIn" sender:self];
}

- (IBAction)createAccountClick:(id)sender {
    [self performSegueWithIdentifier:@"goSignUp" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)unwindForLaunch:(UIStoryboardSegue *)segue{
    
}


@end
