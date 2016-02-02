//
//  ParentVaccinesExperienceViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccinesExperienceViewController.h"
#import "VaccinesParentExperienceTVC.h"
#import "ParentVaccineExperienceDetailsViewController.h"

#import "CJModel.h"

@interface ParentVaccinesExperienceViewController ()<
UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *comments;
    NSIndexPath *editingCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (ParentVaccinesExperienceViewController)
@implementation ParentVaccinesExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

// The function which is derived to reload the data of the visual elements
- (void) reloadData{
    PFQuery *query = [Comment query];
    [query whereKeyExists:@"vaccine"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        if (error) {
            return ;
        }
        comments = [[objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"vaccine.name" ascending:YES],
                                                           [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingCell = indexPath;
    [self performSegueWithIdentifier:@"goParentVaccinesExperienceDetails" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VaccinesParentExperienceTVC *cell = (VaccinesParentExperienceTVC *)[tableView dequeueReusableCellWithIdentifier: @"VaccinesParentExperienceTVCID"];

    // populate cell with information from the current comment in the row
    Comment *comment = comments[indexPath.row];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    cell.dateLabel.text = [df stringFromDate:comment.date];
    cell.nameLabel.text = comment.vaccine.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return comments.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goParentVaccinesExperienceDetails"]) {
        ParentVaccineExperienceDetailsViewController *vc = (ParentVaccineExperienceDetailsViewController *)segue.destinationViewController;
        vc.comment = comments[editingCell.row];
    }
}


@end
