//
//  ParentSignUpViewController.m
//  WithMyBaby
//
//  Created by Nasser on 19.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentSignUpViewController.h"
#import "ParentSignUpTableViewController.h"

#import "CJModel.h"

// The controller of the screen (ParentSignUpViewController)
@interface ParentSignUpViewController (){
    // info keyboard
    CGRect finalKeyboardFrame;
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    BOOL isKeyboardShowed;
}

@property (weak, nonatomic) ParentSignUpTableViewController *childVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerViewButtom;

@end

@implementation ParentSignUpViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _childVC = self.childViewControllers.firstObject;
    
    // Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    // Gesture Recognizer
    UITapGestureRecognizer *gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleGestureRecognizerTap)];
    [_childVC.tableView addGestureRecognizer: gestureRecognizerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
////////////////////////////////////////////////////////////////////
#pragma mark - Recognizers
////////////////////////////////////////////////////////////////////
-(void)handleGestureRecognizerTap{
    [_childVC resignAllFirstResponders];
}

////////////////////////////////////////////////////////////////////
#pragma mark - keyboard
////////////////////////////////////////////////////////////////////

// The function is derived when the keyboard is showed
-(void)keyboardWillShow:(NSNotification *)notification{
    isKeyboardShowed = YES;
    NSDictionary *notificationInfo = [notification userInfo];

    finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window];
    animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];


        _constraintContainerViewButtom.constant = 0.0;
        [_childVC.tableView setNeedsLayout];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];

        _constraintContainerViewButtom.constant = finalKeyboardFrame.size.height;

        [UIView commitAnimations];
}

// The function is derived when the keyboard is hidden
- (void) keyboardWillHide:(NSNotification *)notification{
    isKeyboardShowed = NO;
    [_childVC.tableView setNeedsLayout];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];

    _constraintContainerViewButtom.constant = 0.0;
    [_childVC.tableView setNeedsLayout];

    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The action of Back button is to go back to Signup screen
- (IBAction)backClick:(id)sender {
    [self performSegueWithIdentifier:@"goSignUp" sender:self];
}

// The action of Clear button is to clear the fields
- (IBAction)clearClick:(id)sender {
    [_childVC clearAll];
}

// The action of Submit button is to submit the provided information 
- (IBAction)submitClick:(id)sender {
    [_childVC submit];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
