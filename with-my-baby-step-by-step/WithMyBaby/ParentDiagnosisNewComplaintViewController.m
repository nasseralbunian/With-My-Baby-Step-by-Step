//
//  ParentDiagnosisNewComplaintViewController.m
//  WithMyBaby
//
//  Created by user on 20.01.16.
//  Copyright © 2016 allmax. All rights reserved.
//

#import "ParentDiagnosisNewComplaintViewController.h"
#import "ComplaintTVC.h"
#import "NewMessageViewController.h"

#import "CJModel.h"

@interface ParentDiagnosisNewComplaintViewController ()<
UITableViewDelegate, UITableViewDataSource,
UIPickerViewDataSource, UIPickerViewDelegate>{
    NSIndexPath *editingIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *childrenPickerView;

@end

// The controller of the screen (ParentDiagnosisNewComplaintViewController)
@implementation ParentDiagnosisNewComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingIndexPath = indexPath;
    [self performSegueWithIdentifier:@"goNewMessage" sender:self];
}

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplaintTVC *cell = (ComplaintTVC *)[tableView dequeueReusableCellWithIdentifier: @"ComplaintTVCID"];

    cell.specializationLabel.text = Model.specializations[indexPath.row][@"name"];
    cell.bodyLabel.text = Model.specializations[indexPath.row][@"bodyPart"];
    cell.specialization = Model.specializations[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Model.specializations.count;
}

////////////////////////////////////////////////////////////////////
#pragma mark - UIPIckerViewDelegate
////////////////////////////////////////////////////////////////////
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Child *child = Model.children[row];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    return [NSString stringWithFormat:@"%@ %@", child.name, [df stringFromDate:child.dob]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return Model.children.count;
}

#pragma mark - Navigation

// The function which is derived when the screens change
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goNewMessage"]) {
        NewMessageViewController *vc = (NewMessageViewController *)segue.destinationViewController;
        vc.specialization = ((ComplaintTVC *)[_tableView cellForRowAtIndexPath:editingIndexPath]).specialization;
        vc.child = Model.children[[_childrenPickerView selectedRowInComponent:0]];
        vc.mode = E_NewMessage_NewComplaint;
    }
}


@end
