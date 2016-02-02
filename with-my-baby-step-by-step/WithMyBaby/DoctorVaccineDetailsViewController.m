//
//  DoctorVaccineDetailsViewController.m
//  WithMyBaby
//
//  Created by Nasser on 16.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorVaccineDetailsViewController.h"

#import "CJModel.h"

@interface DoctorVaccineDetailsViewController ()<
UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *vaccineNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *dieseTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextView *sideEffectsTextView;
@property (weak, nonatomic) IBOutlet UITextView *howIsGivenTextView;

@end

// The controller of the screen (DoctorVaccineDetailsViewController)
@implementation DoctorVaccineDetailsViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    //set values for visual elements
    _vaccineNameLabel.text = _vaccine.name;
    _dieseTextField.text = _vaccine.disease;
    
    NSInteger age = [_vaccine.age integerValue];
    _ageTextField.text = [NSString stringWithFormat:@"%d", (int)age];
    
    _sideEffectsTextView.text = _vaccine.sideEffects;
    _howIsGivenTextView.text = _vaccine.howIsGiven;
    
    // add action "textFieldDidChanged" to ageTextField
    [_ageTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////
- (void) resignAllFirstResponders{
    [_dieseTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_sideEffectsTextView resignFirstResponder];
    [_howIsGivenTextView resignFirstResponder];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The function which is derived by click the Submit button
- (IBAction)submitClick:(id)sender {
    [self resignAllFirstResponders];
    
    Vaccine *vaccine = [Vaccine object];
    
    vaccine.disease = _dieseTextField.text;
    vaccine.sideEffects = _sideEffectsTextView.text;
    
    NSInteger age = [_ageTextField.text integerValue];
    vaccine.age = @(age);
    vaccine.previousVaccine = _vaccine;
    vaccine.name = _vaccine.name;
    vaccine.confirmed = NO;
    vaccine.howIsGiven = _howIsGivenTextView.text;
    
    [vaccine saveEventually];
    
    [CJAllertManager presentAllertInController:self text:@"Changes for this vaccine are submited and waiting for administrator approval" message:@"" block:^{
        [self performSegueWithIdentifier:@"goDoctorVaccines" sender:self];
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - TextFieldDelegate
////////////////////////////////////////////////////////////////////
- (void)textFieldDidChanged:(UITextField *)textField{
    NSString *text = textField.text;
    NSString *str = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if (str.length > 3) {
        str = [str substringToIndex:str.length - 1];
    }
    textField.text = str;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllFirstResponders];
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
