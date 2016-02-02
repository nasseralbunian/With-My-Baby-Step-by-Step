//
//  DoctorVaccinesViewController.m
//  WithMyBaby
//
//  Created by Nasser on 16.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorVaccinesViewController.h"
#import "VaccinesTVC.h"
#import "DoctorVaccineDetailsViewController.h"

#import "CJModel.h"

@interface DoctorVaccinesViewController ()<
UITableViewDataSource, UITableViewDelegate
>{
    NSMutableArray *vaccines;
    Vaccine *editingVaccine;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

// The controller of the screen (DoctorVaccinesViewController)
@implementation DoctorVaccinesViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    // get all confirmed vaccines and reload table view
    PFQuery *query = [Vaccine query];
    [query whereKey:@"confirmed" equalTo:@YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        vaccines = [objects mutableCopy];
        vaccines = [[vaccines sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]] mutableCopy];
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////
#pragma mark - UITableView
////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingVaccine = vaccines[indexPath.row];
    [self performSegueWithIdentifier:@"goDoctorVaccineDetails" sender:self];
}

// The function which is derived to manage the table view cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VaccinesTVC *cell = (VaccinesTVC *)[tableView dequeueReusableCellWithIdentifier: @"VaccinesTVCID"];
    
    // set values for visual elements in cell
    Vaccine *vaccine = vaccines[indexPath.row];
    
    // populate table view cell
    cell.nameLabel.text = vaccine.name;
    cell.diseaseLabel.text = vaccine.disease;
    
    NSInteger age = [vaccine.age integerValue];
    // check if age is greator than 12 and set age range label accordingly
    cell.ageRangeLabel.text = age > 12 ?
        [NSString stringWithFormat:@"%dy. %dm.", (int)age / 12, (int)age % 12] :
        [NSString stringWithFormat:@"%dm.", age];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return vaccines.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goDoctorVaccineDetails"]) {
        DoctorVaccineDetailsViewController *vc = (DoctorVaccineDetailsViewController *)segue.destinationViewController;
        vc.vaccine = editingVaccine;
    }
}

-(IBAction)unwindForDoctorVaccines:(UIStoryboardSegue *)segue{
}

@end
