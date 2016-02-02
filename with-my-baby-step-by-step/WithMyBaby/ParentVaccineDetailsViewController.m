//
//  ParentVaccineDetailsViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccineDetailsViewController.h"
#import "ParentVaccineAddExperienceViewController.h"

#import "CJModel.h"

@interface ParentVaccineDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *vaccineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dieaseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRangeLabel;
@property (weak, nonatomic) IBOutlet UITextView *howIsGivenTextView;
@property (weak, nonatomic) IBOutlet UITextView *sideEffectTextView;

@property (weak, nonatomic) IBOutlet UIButton *someButton;
@property (weak, nonatomic) IBOutlet UIButton *parentExperienceButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthParentExperienceButton;

@end

// The controller of the screen (ParentVaccineDetailsViewController)
@implementation ParentVaccineDetailsViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set values for visual elements
    _vaccineNameLabel.text = _vaccine.name;
    _dieaseNameLabel.text = _vaccine.disease;
    
    NSInteger age = [_vaccine.age integerValue];
    _ageRangeLabel.text = age > 12 ?
        [NSString stringWithFormat:@"%d year %d months", (int)age / 12, (int)age % 12] :
        [NSString stringWithFormat:@"%d months", age];
    
    _sideEffectTextView.text = _vaccine.sideEffects;
    _howIsGivenTextView.text = _vaccine.howIsGiven;

    // set title some button (Take or Add parent experience)
    switch (_mode) {
        case E_Vaccine_Due:
        case E_Vaccine_Future:
            [_someButton setTitle:@"Take" forState:UIControlStateNormal];
            for (Vaccine *vaccine in _child.takenVaccines) {
                if ([_vaccine.objectId isEqualToString: vaccine.objectId]) {
                    _someButton.enabled = NO;
                    break;
                }
            }
            break;
        case E_Vaccine_Past:
            _someButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [_someButton setTitle:@"Add parent experience" forState:UIControlStateNormal];
            break;
    }
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////

// The function which is derived by click the current screen button (Add parent experience or Take vaccine)
- (IBAction)someButtonClick:(id)sender {
    if (_mode == E_Vaccine_Past) {
        [self performSegueWithIdentifier:@"goParentVaccineAddExperience" sender:self];
        return;
    }
    
    NSMutableArray *newTakenVaccines = [_child.takenVaccines mutableCopy];
    [newTakenVaccines addObject:_vaccine];
    _child.takenVaccines = newTakenVaccines;
    
    [_child saveEventually];
    
    _someButton.enabled = NO;
    [self performSegueWithIdentifier:@"goParentVaccinesList" sender:self];
}

- (IBAction)parentExperienceButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentVaccinesExperience" sender:self];
}

- (IBAction)backButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentVaccinesList" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goParentVaccineAddExperience"]) {
        ParentVaccineAddExperienceViewController *vc = (ParentVaccineAddExperienceViewController *)segue.destinationViewController;
        vc.vaccine = _vaccine;
    }
}


@end
