//
//  ParentAddExperienceViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccineAddExperienceViewController.h"

#import "CJModel.h"

@interface ParentVaccineAddExperienceViewController (){
    // info keyboard
    CGRect finalKeyboardFrame;
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    BOOL isKeyboardShowed;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewBottom;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

// The controller of the screen (ParentVaccineAddExperienceViewController)
@implementation ParentVaccineAddExperienceViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _vaccine.name;
    
    _textView.text = @"";
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Recognizers
////////////////////////////////////////////////////////////////////
-(void)handleGestureRecognizerTap{
    [_textView resignFirstResponder];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The function which is derived by click the Send button
- (IBAction)sendButtonClick:(id)sender {
    [_textView resignFirstResponder];
    Comment *newComment = [Comment object];
    newComment.text = _textView.text;
    newComment.date = [NSDate date];
    newComment.author = Model.parent;
    newComment.vaccine = _vaccine;
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////
#pragma mark - keyboard
////////////////////////////////////////////////////////////////////

// The function is derived when the keyboard is showed
-(void)keyboardWillShow:(NSNotification *)notification{
    isKeyboardShowed = YES;
    NSDictionary *notificationInfo = [notification userInfo];
    
    // set keyboard values
    finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window];
    animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Animated change size tableView and scroll to current cell
    _constraintTextViewBottom.constant = 8.0;
    [self.textView setNeedsLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _constraintTextViewBottom.constant = finalKeyboardFrame.size.height;
    
    [UIView commitAnimations];
}

// The function is derived when the keyboard is hidden
- (void) keyboardWillHide:(NSNotification *)notification{
    // Animated change size tableView to default values
    isKeyboardShowed = NO;
    [self.textView setNeedsLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _constraintTextViewBottom.constant = 8.0;
    [self.textView setNeedsLayout];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
