//
//  ParentVaccinesViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccinesViewController.h"
#import "ParentVaccinesListViewController.h"

#import "CJModel.h"

@interface ParentVaccinesViewController ()<
UIPickerViewDataSource, UIPickerViewDelegate
>{
    NSMutableArray *takenVaccines;
    E_Vaccine mode;
}
@property (weak, nonatomic) IBOutlet UIButton *pastVaccinesButton;
@property (weak, nonatomic) IBOutlet UIButton *dueVaccinesButton;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

// The controller of the screen (ParentVaccinesViewController)
@implementation ParentVaccinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_picker selectRow:0 inComponent:0 animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self selectChild:[_picker selectedRowInComponent:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////

// The function selects the child to view the vaccines
- (void) selectChild: (NSInteger) index{
    Child *child = Model.children[index];
    // change text in label
    _label.text = [NSString stringWithFormat:@"Vaccines for %@", [child.name capitalizedString]];
    
    // change enabled status for _pastVaccinesButton
    _pastVaccinesButton.enabled = NO;
    NSArray *pastVaccines = child.takenVaccines;
    takenVaccines = [NSMutableArray new];
    __block NSInteger numberVaccines = pastVaccines.count;
    for (Vaccine *vaccine in pastVaccines) {
        [vaccine fetchIfNeededInBackgroundWithBlock:^(PFObject * object, NSError * error) {
            if (error) {
                return ;
            }
            [takenVaccines addObject: object];
            if (--numberVaccines <= 0) {
                _pastVaccinesButton.enabled = YES;
            }
        }];
    }
    
    // change enabled status for _dueVaccinesButton
    PFQuery *query = [Vaccine query];
    _dueVaccinesButton.enabled = NO;
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth
                                                               fromDate:child.dob
                                                                 toDate:[NSDate date]
                                                                options:0];
        
        NSInteger numberMonthesFromAge = dc.year * 12 + dc.month;
        for (Vaccine *vaccine in objects) {
            if (numberMonthesFromAge == [vaccine.age integerValue]){
                _dueVaccinesButton.enabled = YES;
            }
        }
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)dueVaccinesClick:(id)sender {
    mode = E_Vaccine_Due;
    [self performSegueWithIdentifier:@"goParentVaccinesList" sender:self];
}

- (IBAction)futureVaccinesClick:(id)sender {
    mode = E_Vaccine_Future;
    [self performSegueWithIdentifier:@"goParentVaccinesList" sender:self];
}

- (IBAction)pastVaccinesClick:(id)sender {
    mode = E_Vaccine_Past;
    [self performSegueWithIdentifier:@"goParentVaccinesList" sender:self];
}


////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerView
////////////////////////////////////////////////////////////////////
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Child *child = Model.children[row];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear | NSCalendarUnitMonth
                                       fromDate:child.dob
                                       toDate:[NSDate date]
                                       options:0];
    if (!ageComponents.year) {
        return [NSString stringWithFormat:@"%@, %dm.", [child.name capitalizedString], (int)ageComponents.month];
    }else if (!ageComponents.month){
        return [NSString stringWithFormat:@"%@, %dy.", [child.name capitalizedString], (int)ageComponents.year];
    }
    return [NSString stringWithFormat:@"%@, %dy. %dm.", [child.name capitalizedString], (int)ageComponents.year, (int)ageComponents.month];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return Model.children.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self selectChild:row];
}

#pragma mark - Navigation

// The function which is derived when the screens change
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goParentVaccinesList"]) {
        ParentVaccinesListViewController *vc = (ParentVaccinesListViewController *)segue.destinationViewController;
        vc.mode = mode;
        vc.child = Model.children[[_picker selectedRowInComponent:0]];
        if (mode == E_Vaccine_Past) {
            vc.takenVaccines = takenVaccines;
        }
    }
}


@end
