//
//  ParentDiagnosisViewController.m
//  WithMyBaby
//
//  Created by user on 12.01.16.
//  Copyright © 2016 allmax. All rights reserved.
//

#import "ParentDiagnosisViewController.h"
#import "InquiriesTVC.h"
#import "ChatViewController.h"

#import "CJModel.h"

@interface ParentDiagnosisViewController ()<
UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *complaints;
    NSIndexPath *selectedCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (ParentDiagnosisViewController)
@implementation ParentDiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// The function is derived for the each visible screen
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFQuery *query = [Complaint query];
    
    if (_mode == E_ParentDiagnosis_MyChildren) {
        [query whereKey:@"child" containedIn:Model.children];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        if (error) {
            return ;
        }
        complaints = [objects mutableCopy];
        complaints = [[complaints sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES],
                                                                [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)consultClick:(id)sender {
    [self performSegueWithIdentifier:@"goNewComplaint" sender:self];
}

- (IBAction)parentExperienceClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentsExperience" sender:self];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////

// The function which determines the buttons of the table view cell
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *myButtonDelete = [UITableViewRowAction
                                            rowActionWithStyle:UITableViewRowActionStyleDefault
                                            title:@"Delete"
                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                UIAlertController *alertController = [UIAlertController
                                                                                      alertControllerWithTitle: @"Are you sure?"
                                                                                      message: @""
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction *action){
                                                                                                      Complaint *complaint = complaints[indexPath.row];
                                                                                                      [complaints removeObject:complaint];
                                                                                                      [complaint deleteEventually];
                                                                                                      [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                                  }];
                                                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                 handler:^(UIAlertAction *action){
                                                                                                 }];
                                                [alertController addAction:yesAction];
                                                [alertController addAction:noAction];
                                                
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }];
    
    return @[myButtonDelete];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}


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
    if ([segue.identifier isEqualToString:@"goChat"]) {
        ChatViewController *vc = (ChatViewController *)segue.destinationViewController;
        vc.complaint = complaints[selectedCell.row];
        if (_mode == E_ParentDiagnosis_Experience_Parent) {
            vc.mode = E_Chat_Parent_Viewer;
            vc.messageMode = E_ChatMessage_ConfirmedOnly;
        }else if(_mode == E_ParentDiagnosis_Experience_Doctor){
            vc.mode = E_Chat_Doctor;
            vc.messageMode = E_ChatMessage_All;
        }else{ // _mode == E_ParentDiagnosis_MyChildren
            vc.mode = E_Chat_Parent;
            vc.messageMode = E_ChatMessage_ConfirmedOnly;
        }
    }else if ([segue.identifier isEqualToString:@"goParentsExperience"]){
        ParentDiagnosisViewController *vc = (ParentDiagnosisViewController *)segue.destinationViewController;
        vc.mode = E_ParentDiagnosis_Experience_Parent;
    }
}

- (IBAction)unwindForParentDiagnosis:(UIStoryboardSegue *)segue{
}


@end
