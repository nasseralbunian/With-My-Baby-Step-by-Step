//
//  DoctorDiagnosisViewController.m
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorDiagnosisViewController.h"
#import "InquiriesTVC.h"
#import "ChatViewController.h"
#import "ParentDiagnosisViewController.h"

#import "CJModel.h"

@interface DoctorDiagnosisViewController ()<
UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *complaints;
    NSIndexPath *selectedCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

// The controller of the screen (DoctorDiagnosisViewController)
@implementation DoctorDiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
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

// The function of the screen loading
- (void) reloadData{
    // prepare query for speciality by doctor's speciality
    PFQuery *query = [Complaint query];
    [query whereKey:@"speciality" equalTo: Model.doctor.speciality];
    // add condition to query based upon which segment user is in on UI
    switch (_segmentedControl.selectedSegmentIndex) {
        case 1:
            // fetch new messages
            [query whereKey:@"status" equalTo:@(E_Message_New)];
            break;
        case 2:
            // fetch open messages
            [query whereKey:@"status" equalTo:@(E_Message_Open)];
            break;
        case 3:
            // fetch closed messages
            [query whereKey:@"status" equalTo:@(E_Message_Close)];
            break;
    }
    
    // fetch query results in background
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        // return if error
        if (error) {
            return ;
        }
        // copy results in array
        complaints = [objects mutableCopy];
        // sort array for ascending status and descending date 
        complaints = [[complaints sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES],
                                                                [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        });
    }];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)statusValueChanged:(id)sender {
    [self reloadData];
}

- (IBAction)parentExperienceClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentsExperience" sender:self];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCell = indexPath;
    [self performSegueWithIdentifier:@"goChat" sender:self];
}

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InquiriesTVC *cell = (InquiriesTVC *)[tableView dequeueReusableCellWithIdentifier: @"InquiriesTVCID"];
    
    Complaint *complaint = complaints[indexPath.row];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    cell.labelDate.text = [df stringFromDate:complaint.date];
    cell.labelStatus.text = [Model complaintStatus:complaint.status];
    cell.labelText.text = complaint.text;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return complaints.count;
}

#pragma mark - Navigation

// The function which is derived when the screens change
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // if it should go to chat 
    if ([segue.identifier isEqualToString:@"goChat"]) {
        // create chat view controller
        ChatViewController *vc = (ChatViewController *)segue.destinationViewController;
        vc.complaint = complaints[selectedCell.row];
        vc.mode = E_Chat_Doctor;
        vc.messageMode = E_ChatMessage_All;
    }else if ([segue.identifier isEqualToString:@"goParentsExperience"]){ // if it should go to parent experience
        // create parent diagnosis controller
        ParentDiagnosisViewController *vc = (ParentDiagnosisViewController *)segue.destinationViewController;
        vc.mode = E_ParentDiagnosis_Experience_Doctor;
    }
}

- (IBAction)unwindForDoctorDiagnosis:(UIStoryboardSegue *)segue{
}

@end
