//
//  DoctorMainViewController.m
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "DoctorMainViewController.h"
#import "ButtonStyleCollectionViewCell.h"

#import "CJModel.h"

@interface DoctorMainViewController ()<
UICollectionViewDelegate, UICollectionViewDataSource>{
    Doctor *doctor;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

// The controller of the screen (DoctorDiagnosisViewController)
@implementation DoctorMainViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    //set title
    NSString* name = Model.doctor.firstname.length > 0? [[Model.doctor.firstname substringToIndex:1] capitalizedString]: nil;
    NSString* lastname = [Model.doctor.lastname capitalizedString];
    
    if (!lastname) {
        lastname = @"";
    }
    
    if (!name) {
        self.title = [NSString stringWithFormat:@"%@", lastname];
    }else{
        self.title = [NSString stringWithFormat:@"%@. %@",name, lastname];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Clicks
////////////////////////////////////////////////////////////////////
- (IBAction)logoutClick:(id)sender {
    [Manager logout];
    [self performSegueWithIdentifier:@"goLaunch" sender:self];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Collection View Delegate
////////////////////////////////////////////////////////////////////

// The function which is derived when the cell is selected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self performSegueWithIdentifier:@"goDoctorVaccines" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"goDoctorNutrition" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"goDoctorDiagnosis" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"goSettings" sender:self];
            break;
        default:
            break;
    }
}


// The function which is derived to manage the collection view cell design
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ButtonStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonStyleCVCID" forIndexPath:indexPath];
     
    NSInteger row = indexPath.row;
    // set cell label according to row
    switch (row) {
        case 0:
            cell.image.image = [UIImage imageNamed:@"Vaccines"];
            cell.nameLabel.text = @"Vaccines";
            break;
        case 1:
            cell.image.image = [UIImage imageNamed:@"Nuitrition"];
            cell.nameLabel.text = @"Nutrition";
            break;
        case 2:
            cell.image.image = [UIImage imageNamed:@"Diagnosis"];
            cell.nameLabel.text = @"Diagnosis";
            break;
        case 3:
            cell.image.image = [UIImage imageNamed:@"settings"];
            cell.nameLabel.text = @"Settings";
            break;
        default:
            break;
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)unwindToParentMain:(UIStoryboardSegue *)segue{
}

@end
