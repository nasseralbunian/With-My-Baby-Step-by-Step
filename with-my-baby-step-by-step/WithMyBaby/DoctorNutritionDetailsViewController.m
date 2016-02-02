//
//  DoctorNutritionDetailsViewController.m
//  WithMyBaby
//
//  Created by Nasser on 15.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorNutritionDetailsViewController.h"
#import "DoctorNutritionDetailsTVC.h"

#import "CJModel.h"

@interface DoctorNutritionDetailsViewController ()<
UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate>{
    NSMutableArray *values;
    
    // info keyboard
    CGRect finalKeyboardFrame;
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    BOOL isKeyboardShowed;
    
    NSIndexPath *editingTextFieldIndexPath;
    UITextField *editingTextField;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewBottom;

@end

// The controller of the screen (DoctorNutritionDetailsViewController)
@implementation DoctorNutritionDetailsViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    values = [@[_nutrition.fruits,
                _nutrition.vegetables,
                _nutrition.grains,
                _nutrition.meatsAndBeans,
                _nutrition.milk,
                _nutrition.oils] mutableCopy];
    
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
    [self.tableView addGestureRecognizer: gestureRecognizerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////


- (void) resignAllFirstResponders{
    for (NSInteger i = 0; i < values.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DoctorNutritionDetailsTVC *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        [cell.dailyServingTextField resignFirstResponder];
    }
    
    [editingTextField resignFirstResponder];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Recognizers
////////////////////////////////////////////////////////////////////
-(void)handleGestureRecognizerTap{
    [self resignAllFirstResponders];
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
    
    // find current textField
    UIView *textField = nil;
    NSIndexPath *indexPath;
    for (NSInteger i = 0; i < values.count; ++i) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DoctorNutritionDetailsTVC *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.dailyServingTextField isFirstResponder]) {
            textField = cell.dailyServingTextField;
            break;
        }
    }
    
    if (textField){
        // Animated change size tableView and scroll to current cell
        _constraintTableViewBottom.constant = 0.0;
        [self.tableView setNeedsLayout];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        _constraintTableViewBottom.constant = finalKeyboardFrame.size.height;
        
        [UIView commitAnimations];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

// The function is derived when the keyboard is hidden
- (void) keyboardWillHide:(NSNotification *)notification{
    // Animated change size tableView to default values
    isKeyboardShowed = NO;
    [self.tableView setNeedsLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _constraintTableViewBottom.constant = 0.0;
    [self.tableView setNeedsLayout];
    
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The function which is derived by click the Submit button
- (IBAction)submitButtonClick:(id)sender {
    [self resignAllFirstResponders];
    Nutrition *nutrition = [Nutrition object];
    
    nutrition.age = _nutrition.age;
    nutrition.gender = _nutrition.gender;
    nutrition.fruits = values[0];
    nutrition.vegetables = values[1];
    nutrition.grains = values[2];
    nutrition.meatsAndBeans = values[3];
    nutrition.milk = values[4];
    nutrition.oils = values[5];
    nutrition.previousNutrition = _nutrition;
    nutrition.confirmed = NO;
    
    [nutrition saveEventually];
    
    [CJAllertManager presentAllertInController:self text:@"Changes for this nutrition are submited and waiting for administrator approval" message:@"" block:^{
        [self performSegueWithIdentifier:@"goDoctorNutrition" sender: self];
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorNutritionDetailsTVC *cell = (DoctorNutritionDetailsTVC *)[tableView dequeueReusableCellWithIdentifier: @"DoctorNutritionDetailsTVCID"];
    // set cell properties for different nutritions according to row
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"Fruits";
            cell.dailyServingTextField.text = values[0];
            cell.sizeLabel.text = @"cups";
            break;
        case 1:
            cell.nameLabel.text = @"Vegetables";
            cell.dailyServingTextField.text = values[1];
            cell.sizeLabel.text = @"cups";
            break;
        case 2:
            cell.nameLabel.text = @"Grains";
            cell.dailyServingTextField.text = values[2];
            cell.sizeLabel.text = @"ounces";
            break;
        case 3:
            cell.nameLabel.text = @"Meats and Beans";
            cell.dailyServingTextField.text = values[3];
            cell.sizeLabel.text = @"ounces";
            break;
        case 4:
            cell.nameLabel.text = @"Milk";
            cell.dailyServingTextField.text = values[4];
            cell.sizeLabel.text = @"cups";
            break;
        case 5:
            cell.nameLabel.text = @"Oils";
            cell.dailyServingTextField.text = values[5];
            cell.sizeLabel.text = @"tsp";
            break;
            
        default:
            break;
    }
    
    cell.dailyServingTextField.delegate = self;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

////////////////////////////////////////////////////////////////////
#pragma mark - TextFields
////////////////////////////////////////////////////////////////////
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (![[[textField superview] superview] isKindOfClass: [UITableViewCell class]]) {
        return;
    }
    editingTextFieldIndexPath = [self.tableView indexPathForCell: (UITableViewCell *)[[textField superview] superview]];
    editingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [values replaceObjectAtIndex:editingTextFieldIndexPath.row withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllFirstResponders];
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
