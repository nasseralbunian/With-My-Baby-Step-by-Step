//
//  ParentNutritionViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentNutritionViewController.h"
#import "ParentNutritionTVC.h"

#import "CJModel.h"

@interface ParentNutritionViewController ()<
UITableViewDelegate, UITableViewDataSource,
UIPickerViewDelegate, UIPickerViewDataSource
>{
    NSArray *children;
    
    Nutrition *nutrition;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (ParentNutritionViewController)
@implementation ParentNutritionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    children = Model.children;
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////

// The function which is derived to reload the data of the visual elements
- (void) reloadData{
    Child *selectedChild = children[[_pickerView selectedRowInComponent:0]];
    NSInteger age = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                    fromDate:selectedChild.dob
                                                      toDate:[NSDate date]
                                                     options:0].year;
    PFQuery *query = [Nutrition query];
    [query whereKey:@"age" equalTo:@(age)];
    [query whereKey:@"gender" containedIn:@[@((int)selectedChild.gender), @(2)]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        
        for (Nutrition *nut in objects) {
            if (nut.confirmed == YES) {
                nutrition = nut;
                break;
            }
        }
        
        [_tableView reloadData];
    }];
    
}

////////////////////////////////////////////////////////////////////
#pragma mark - PickerView
////////////////////////////////////////////////////////////////////
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Child *selectedChild = children[row];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    return [NSString stringWithFormat:@"%@, %@", ((Child *)children[row]).name, [df stringFromDate:selectedChild.dob]];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return children.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self reloadData];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParentNutritionTVC *cell = (ParentNutritionTVC *)[tableView dequeueReusableCellWithIdentifier: @"ParentNutritionTVCID"];

    // set cell properties for nutrion based on the selected row  
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"Fruits";
            cell.dailyServingLabel.text = nutrition.fruits;
            cell.sizeLabel.text = @"cups";
            break;
        case 1:
            cell.nameLabel.text = @"Vegetables";
            cell.dailyServingLabel.text = nutrition.vegetables;
            cell.sizeLabel.text = @"cups";
            break;
        case 2:
            cell.nameLabel.text = @"Grains";
            cell.dailyServingLabel.text = nutrition.grains;
            cell.sizeLabel.text = @"ounces";
            break;
        case 3:
            cell.nameLabel.text = @"Meats and Beans";
            cell.dailyServingLabel.text = nutrition.meatsAndBeans;
            cell.sizeLabel.text = @"ounces";
            break;
        case 4:
            cell.nameLabel.text = @"Milk";
            cell.dailyServingLabel.text = nutrition.milk;
            cell.sizeLabel.text = @"cups";
            break;
        case 5:
            cell.nameLabel.text = @"Oils";
            cell.dailyServingLabel.text = nutrition.oils;
            cell.sizeLabel.text = @"tsp";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
