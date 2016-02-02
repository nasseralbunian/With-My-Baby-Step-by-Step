//
//  NewMessageViewController.m
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "NewMessageViewController.h"

#import "CJModel.h"

@interface NewMessageViewController (){
    // info keyboard
    CGRect finalKeyboardFrame;
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    BOOL isKeyboardShowed;    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewBottom;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

// The controller of the screen (NewMessageViewController)
@implementation NewMessageViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (IBAction)sendClick:(id)sender {
    [_textView resignFirstResponder];
    // if mode is new complaint
    if (_mode == E_NewMessage_NewComplaint) {
        // create new complaint object and populate with user provided data in UI fields 
        Complaint *newComplaint = [Complaint object];
        newComplaint.child = _child;
        newComplaint.text = _textView.text;
        newComplaint.status = E_Message_New;
        //newComplaint.status = 1;
        newComplaint.date = [NSDate date];
        newComplaint.speciality = _specialization[@"name"];
        
        // save new complaint in background
        [newComplaint saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self performSegueWithIdentifier:@"goParentDiagnosis" sender:self];
        }];
    }else if (_mode == E_NewMessage_NewComment){        // if mode is new comment
        // create new comment object and populate with user provided data in UI fields
        Comment *newComment = [Comment object];
        newComment.text = _textView.text;
        newComment.date = [NSDate date];
        newComment.author = Model.parent;
        newComment.complaint = _complaint;
        
        _complaint.status = 0;
        
        // save new comment in background
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (_mode == E_NewMessage_NewDiagnosis){
        
        // create new diagnosis object and populate with user provided data in UI fields
        Diagnosis *newDiagnosis = [Diagnosis object];
        newDiagnosis.text = _textView.text;
        newDiagnosis.date = [NSDate date];
        newDiagnosis.doctor = Model.doctor;
        newDiagnosis.complaint = _complaint;
        //newDiagnosis.moderated = NO;
        newDiagnosis.moderated = YES;
        
        _complaint.status = 1;
        
        // save new diagnosis in background
        [newDiagnosis saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}

- (IBAction)backClick:(id)sender {
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
