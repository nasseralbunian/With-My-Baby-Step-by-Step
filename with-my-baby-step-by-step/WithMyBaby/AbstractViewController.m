//
//  AbstractViewController.m
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AbstractViewController.h"
#import "CJModel.h"

// Abstract controller, supports the shift elements when displaying keyboard
@interface AbstractViewController (){
    // info keyboard
    CGRect finalKeyboardFrame;
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    BOOL isKeyboardShowed;
}

@end

// The abstract controller which is used to manage the space between the keyboard and the textFields
@implementation AbstractViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addGestureRecognizer: gestureRecognizerTap];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setHeightNavigationBarIfNeed:44.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////

// The setting of the height of the navigation bar
- (void) setHeightNavigationBar: (float) height{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    CGRect frame = navigationBar.frame;
    frame.size.height = height;
    [navigationBar setFrame:frame];
    
    frame = self.navigationItem.titleView.frame;
    frame.origin.y = 0;
    [self.navigationItem.titleView setFrame:frame];
    [self.navigationItem.titleView setNeedsDisplay];
    [navigationBar setNeedsDisplay];
}

- (void) setHeightNavigationBarIfNeed: (float) height{
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationIsLandscape((UIDeviceOrientation)newOrientation)) {
        [self setHeightNavigationBar:height];
    }
}

////////////////////////////////////////////////////////////////////
#pragma mark - Recognizers
////////////////////////////////////////////////////////////////////
-(void)handleGestureRecognizerTap{
    NSArray *subviews = self.view.subviews;
    for (UIView *subview in subviews) {
        [subview resignFirstResponder];
    }
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
    
    UIView *textField = nil;
    for (UIView *view in self.view.subviews){
        if (view.isFirstResponder){
            textField = view;
            break;
        }
    }
    if (textField){
        CGFloat keyboardHeight = finalKeyboardFrame.size.height;

        CGFloat bottomTextField = ViewY(textField) + ViewHeight(textField);

        CGFloat heightToUp = (ViewHeight(self.view) - keyboardHeight) - bottomTextField;

        if (heightToUp >= 0) {
            return;
        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];

        self.view.transform = CGAffineTransformMakeTranslation(0, heightToUp);

        [UIView commitAnimations];
    }
}

// The function is derived when the keyboard is hidden 
- (void) keyboardWillHide:(NSNotification *)notification{
    isKeyboardShowed = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    
    [UIView commitAnimations];
}

@end
