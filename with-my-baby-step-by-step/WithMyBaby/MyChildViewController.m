//
//  MyChildViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "MyChildViewController.h"
#import "MyChildTVC.h"
#import "AddMyChildViewController.h"

#import "CJModel.h"

@interface MyChildViewController ()<
UIPopoverPresentationControllerDelegate,
CJModelDelegate
>{
    NSMutableArray *myChildren;
    Child *editingChild;
    NSIndexPath *editingIndexPathCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (MyChildViewController)
@implementation MyChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    Model.delegate = self;
    myChildren = [Model.children mutableCopy];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)backButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"goParentMain" sender:self];
}

- (IBAction)addButtonCLick:(id)sender {
    editingChild = nil;
    editingIndexPathCell = nil;
    [self performSegueWithIdentifier:@"goAddChild" sender:self];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////

// The function which determines the buttons of the table view cell
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // add delete button
    UITableViewRowAction *myButtonDelete = [UITableViewRowAction
                                            rowActionWithStyle:UITableViewRowActionStyleDefault
                                            title:@"Delete"
                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                // generating allert view, and present
                                                UIAlertController *alertController = [UIAlertController
                                                                                      alertControllerWithTitle: @"Are you sure?"
                                                                                      message: @""
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                // action for yes 
                                                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                 handler:^(UIAlertAction *action){
                                                                                                     Child *child = myChildren[indexPath.row];
                                                                                                     [myChildren removeObject:child];
                                                                                                     [child deleteEventually];
                                                                                                     [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                                     [Model reloadChildren];
                                                                                                 }];
                                                // action for no
                                                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                 handler:^(UIAlertAction *action){
                                                                                                 }];
                                                // add both actions to alert controller
                                                [alertController addAction:yesAction];
                                                [alertController addAction:noAction];
                                                
                                                // animate it to be visible
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }];
    
    return @[myButtonDelete];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

// The function which is derived when the cell is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingChild = myChildren[indexPath.row];
    editingIndexPathCell = indexPath;
    [self performSegueWithIdentifier:@"goAddChild" sender:self];
}

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyChildTVC *cell = (MyChildTVC *)[tableView dequeueReusableCellWithIdentifier: @"MyChildTVCID"];
    
    // get child at current row
    Child *child = myChildren[indexPath.row];
    
    // fill cell with child info 
    cell.nameLabel.text = child.name;
    
    // set date format to be short in style
    NSDateFormatter * df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    
    // set child age label in cell
    cell.ageLabel.text = [df stringFromDate:child.dob];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myChildren.count;
}

////////////////////////////////////////////////////////////////////
#pragma mark - UIPresentationControllerDelegate
////////////////////////////////////////////////////////////////////
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

////////////////////////////////////////////////////////////////////
#pragma mark - CJModelDelegate
////////////////////////////////////////////////////////////////////
- (void)model:(CJModel *)model changeChildren:(NSArray *)children{
    myChildren = [Model.children mutableCopy];
    [_tableView reloadData];
}

#pragma mark - Navigation

// The function which is derived when the screens change 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goAddChild"]) {
        AddMyChildViewController *vc = (AddMyChildViewController *)segue.destinationViewController;
        vc.preferredContentSize = CGSizeMake(300,354);
        UIPopoverPresentationController *controller = vc.popoverPresentationController;
        if (controller) {
            controller.delegate = self;
            if (editingIndexPathCell) {
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath: editingIndexPathCell];
                controller.sourceView = cell;
                controller.sourceRect = cell.frame;
            }
        }
        vc.child = editingChild;
    }
}

- (IBAction)unwindToMyChild:(UIStoryboardSegue *)segue{
}

@end
