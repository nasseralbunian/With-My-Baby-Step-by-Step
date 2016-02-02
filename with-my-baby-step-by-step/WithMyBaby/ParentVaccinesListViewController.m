//
//  ParentVaccinesListViewController.m
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentVaccinesListViewController.h"
#import "VaccinesTVC.h"
#import "ParentVaccineDetailsViewController.h"

#import "CJModel.h"

@interface ParentVaccinesListViewController ()<
UITableViewDataSource, UITableViewDelegate
>{
    NSMutableArray *vaccines;
    Vaccine *editingVaccine;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (ParentVaccinesListViewController)
@implementation ParentVaccinesListViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_mode == E_Vaccine_Past) {
        vaccines = [_takenVaccines mutableCopy];
        vaccines = [[vaccines sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]] mutableCopy];
        [_tableView reloadData];
        
        self.title = @"Past vaccines";
    }else{
        if (_mode == E_Vaccine_Due) {
            self.title = @"Due vaccines";
        }else{
            self.title = @"All vaccines";
        }
        // get all confirmed vaccines objects and reload table view
        PFQuery *query = [Vaccine query];
        [query whereKey:@"confirmed" equalTo:@YES];
        [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
            if (_mode == E_Vaccine_Future) {
                vaccines = [objects mutableCopy];
                vaccines = [[vaccines sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]] mutableCopy];
                [_tableView reloadData];
                return ;
            }
            
            // _mode == E_Vaccine_Due
            vaccines = [NSMutableArray new];
            
            NSInteger maxMonth = [((Vaccine *)objects[0]).age integerValue];
            
            for (Vaccine *vaccine in objects) {
                if (maxMonth <= [vaccine.age integerValue]) {
                    maxMonth = [vaccine.age integerValue];
                }
            }
            
            NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth
                                                                   fromDate:_child.dob
                                                                     toDate:[NSDate date]
                                                                    options:0];
            
            NSInteger numberMonthsFromAge = dc.year * 12 + dc.month;
            for (NSInteger i = numberMonthsFromAge; i <= maxMonth; ++i) {
                for (Vaccine *vaccine in objects) {
                    if ([vaccine.age integerValue] == i) {
                        [vaccines addObject:vaccine];
                    }
                }
                
                if (vaccines.count) {
                    break;
                }
            }
            
            vaccines = [[vaccines sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]] mutableCopy];
            [_tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingVaccine = vaccines[indexPath.row];
    [self performSegueWithIdentifier:@"goParentVaccineDetails" sender:self];
}

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VaccinesTVC *cell = (VaccinesTVC *)[tableView dequeueReusableCellWithIdentifier: @"VaccinesTVCID"];

    // populate cell with current vaccine information
    Vaccine *vaccine = vaccines[indexPath.row];
    cell.nameLabel.text = vaccine.name;
    cell.diseaseLabel.text = vaccine.disease;
    NSInteger age = [vaccine.age integerValue];
    cell.ageRangeLabel.text = age > 12 ?
        [NSString stringWithFormat:@"%dy. %dm.", (int)age / 12, (int)age % 12] :
        [NSString stringWithFormat:@"%dm.", age];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return vaccines.count;
}

#pragma mark - Navigation

// The function which is derived when the screens change
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goParentVaccineDetails"]) {
        ParentVaccineDetailsViewController *vc = (ParentVaccineDetailsViewController *)segue.destinationViewController;
        vc.child = _child;
        vc.mode = _mode;
        vc.vaccine = editingVaccine;
    }
}

- (IBAction)unwindForParentVaccinesList:(UIStoryboardSegue *)segue {
}


@end
