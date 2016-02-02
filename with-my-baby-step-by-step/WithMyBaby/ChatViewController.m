//
//  ChatViewController.m
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTVC.h"
#import "NewMessageViewController.h"

#import "CJModel.h"

@interface ChatViewController ()<
UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *messages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addMessageButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeStatusButton;

@end

// The controller of the screen (ChatViewController)
@implementation ChatViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    if (_mode != E_Chat_Parent) {
        _changeStatusButton.enabled = false;
    }
}

// The function is derived for the each visible screen
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _statusLabel.text = [Model complaintStatus:_complaint.status];
    if (_complaint.status == 2 && _addMessageButton) {
        _addMessageButton.enabled = false;
    }
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
    messages = [NSMutableArray new];
    [messages addObject:_complaint];
    __block NSInteger numberQuery = 2;
    
    // prepare query to find comment
    PFQuery *queryComment = [Comment query];
    [queryComment whereKey:@"complaint" equalTo:_complaint];
    
    // fetch results in background
    [queryComment findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        // not found do nothing
        if (error) {
            return ;
        }
        // add result to array
        [messages addObjectsFromArray:objects];
        numberQuery--;
        if (!numberQuery) {
            // sort the array ascending for date
            messages = [[messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
            });
        }
    }];
    
    // prepare query to find diagnosis
    PFQuery *queryDiagnosis = [Diagnosis query];
    [queryDiagnosis whereKey:@"complaint" equalTo:_complaint];
//    if (_messageMode == E_ChatMessage_ConfirmedOnly) {
//        [queryDiagnosis whereKey:@"moderated" equalTo:@YES];
//    }

    // fetch results in background
    [queryDiagnosis findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        // if error then return
        if (error) {
            return ;
        }
        
        // add found diagnosis' to array
        [messages addObjectsFromArray:objects];
        numberQuery--;
        
        if (!numberQuery) {
            // sort array ascending for date
            messages = [[messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
            });
        }
    }];
}
////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)addMessageClick:(id)sender {
    [self performSegueWithIdentifier:@"goNewMessage" sender:self];
}

// The function which is derived by click the Status button
- (IBAction)changeStatusClick:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle: @"Change status"
                                          message: @""
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    // action for user's cancel operation
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){
                                                         }];
    // action for user's open operation
    UIAlertAction *OpenAction = [UIAlertAction actionWithTitle:@"Open"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             _complaint.status = 1;
                                                             [_complaint saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     _statusLabel.text = [Model complaintStatus:_complaint.status];
                                                                     if (_complaint.status == 2 && _addMessageButton) {
                                                                         _addMessageButton.enabled = false;
                                                                     }
                                                                 });
                                                             }];
                                                         }];
    // action for user's close operation
    UIAlertAction *CloseAction = [UIAlertAction actionWithTitle:@"Close"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             _complaint.status = 2;
                                                             [_complaint saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     _statusLabel.text = [Model complaintStatus:_complaint.status];
                                                                     if (_complaint.status == 2 && _addMessageButton) {
                                                                         _addMessageButton.enabled = false;
                                                                     }
                                                                 });
                                                             }];
                                                         }];
    // add actions to controller
    [alertController addAction:OpenAction];
    [alertController addAction:CloseAction];
    [alertController addAction:CancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTVC *cell;
    id message = messages[indexPath.row];
    if (_mode == E_Chat_Doctor) {
        if ([message isKindOfClass: [Diagnosis class]]) {
            cell = (ChatTVC *)[tableView dequeueReusableCellWithIdentifier: @"ChatTVCCommentID"];
        }else{
            cell = (ChatTVC *)[tableView dequeueReusableCellWithIdentifier: @"ChatTVCDiagnosisID"];
        }
    }else{
        if ([message isKindOfClass: [Diagnosis class]]) {
            cell = (ChatTVC *)[tableView dequeueReusableCellWithIdentifier: @"ChatTVCDiagnosisID"];
        }else{
            cell = (ChatTVC *)[tableView dequeueReusableCellWithIdentifier: @"ChatTVCCommentID"];
        }
    }
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    cell.labelDate.text = [df stringFromDate:message[@"date"]];
    cell.labelText.text = message[@"text"];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messages.count;
}

// The function which is derived to regulate the table view cell height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id message = messages[indexPath.row];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:message[@"text"] attributes:@{[UIFont fontWithName:@"HelveticaNeue" size:14.] : NSFontAttributeName}];
    CGFloat width = ScreenWidth * 2. / 3.;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil]; 
    return rect.size.height * 1.25 + 20;
}

#pragma mark - Navigation

// The function which is derived when the screens change 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goNewMessage"]) {
        NewMessageViewController *vc = (NewMessageViewController *)segue.destinationViewController;
        vc.complaint = _complaint;
        vc.mode = _mode == E_Chat_Doctor? E_NewMessage_NewDiagnosis : E_NewMessage_NewComment;
    }
}

@end
