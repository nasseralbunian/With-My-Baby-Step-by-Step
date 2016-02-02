//
//  ParentVaccineExperienceDetailsViewController.m
//  WithMyBaby
//
//  Created by Nasser on 21.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccineExperienceDetailsViewController.h"

#import "CJModel.h"

@interface ParentVaccineExperienceDetailsViewController (){
    Vaccine *vaccine;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

// The controller of the screen (ParentVaccineExperienceDetailsViewController)
@implementation ParentVaccineExperienceDetailsViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = @"";
    _dateLabel.text = @"";
    _textView.text = @"";
    
    vaccine = _comment.vaccine;
    
    if (vaccine) {
        [vaccine fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                return ;
            }
            vaccine = (Vaccine *)object;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _nameLabel.text = vaccine.name;
                NSDateFormatter *df = [NSDateFormatter new];
                df.dateStyle = NSDateFormatterShortStyle;
                _dateLabel.text = [df stringFromDate:_comment.date];
                _textView.text = _comment.text;
            });
        }];
    }
    
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
