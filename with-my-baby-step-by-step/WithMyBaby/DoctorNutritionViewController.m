//
//  DoctorNutritionViewController.m
//  WithMyBaby
//
//  Created by Nasser on 15.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorNutritionViewController.h"
#import "DoctorNutritionDetailsViewController.h"
#import "DoctorNutritionTVC.h"

#import "CJModel.h"

@interface DoctorNutritionViewController ()<
UITableViewDataSource, UITableViewDelegate>{
    NSArray *nutritions;
    Nutrition *editingNutrition;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (ParentMainViewController)
@implementation DoctorNutritionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other Functions
////////////////////////////////////////////////////////////////////


- (void) reloadData{
    // get all confirmed nutritions objects and reload table view
    PFQuery *query = [Nutrition query];
    [query whereKey:@"confirmed" equalTo:@(YES)];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        if (error) {
            return ;
        }
        nutritions = [objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES],
                                                            [NSSortDescriptor sortDescriptorWithKey:@"gender" ascending:NO]]];
        [_tableView reloadData];
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingNutrition = nutritions[indexPath.row];
    [self performSegueWithIdentifier:@"goDoctorNutritionDetails" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorNutritionTVC *cell = (DoctorNutritionTVC *)[tableView dequeueReusableCellWithIdentifier: @"DoctorNutritionTVCID"];

    Nutrition *nutrition = nutritions[indexPath.row];
    NSString *gender;
    // display gender based upon what gender this nutrion is for
    switch (nutrition.gender) {
        case 0:
            gender = @"Female";
            break;
        case 1:
            gender = @"Male";
            break;
        case 2:
            gender = @"All";
            break;
    }
    cell.ageLabel.text = [NSString stringWithFormat:@"%d y.o. diet, %@", nutrition.age, gender];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nutritions.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goDoctorNutritionDetails"]) {
        DoctorNutritionDetailsViewController *vc = segue.destinationViewController;
        vc.nutrition = editingNutrition;
    }
}

- (IBAction)unwindToDoctorNutrition:(UIStoryboardSegue *)segue{
}

@end
