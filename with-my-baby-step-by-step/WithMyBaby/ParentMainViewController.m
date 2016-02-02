//
//  ParentMainViewController.m
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "ParentMainViewController.h"
#import "ButtonStyleCollectionViewCell.h"

#import "ParentDiagnosisViewController.h"
#import "MyChildViewController.h"

#import "CJModel.h"

@interface ParentMainViewController ()<
UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

// The controller of the screen (ParentMainViewController)
@implementation ParentMainViewController

// The function of the screen loading
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    // set title
    NSString* name = Model.parent.firstname.length > 0? [[Model.parent.firstname substringToIndex:1] capitalizedString]: nil;
    NSString* lastname = [Model.parent.lastname capitalizedString];
    
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
    // forward to relevant screen according to current collection view row
    switch (row) {
        case 0:
            [self performSegueWithIdentifier:@"goMyChild" sender:self];
            break;
        case 1:
            if (!Model.children || !Model.children.count) {
                [CJAllertManager presentAllertInController:self text:@"You have no records in \"My children\" menu" message:@"Please add a record in \"My Children\" menu" block:^{
                    
                }];
            }else{
                [self performSegueWithIdentifier:@"goParentVaccines" sender:self];
            }
            break;
        case 2:
            if (!Model.children || !Model.children.count) {
                [CJAllertManager presentAllertInController:self text:@"You have no records in \"My children\" menu" message:@"Please add a record in \"My Children\" menu" block:^{
                    
                }];
            }else{
                [self performSegueWithIdentifier:@"goParentNutrition" sender:self];
            }
            break;
        case 3:
            if (!Model.children || !Model.children.count) {
                [CJAllertManager presentAllertInController:self text:@"You have no records in \"My children\" menu" message:@"Please add a record in \"My Children\" menu" block:^{
                    
                }];
            }else{
                [self performSegueWithIdentifier:@"goParentDiagnosis" sender:self];
            }
            break;
        case 4:
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
    
    // set cell data based on selected row
    switch (row) {
        case 0:
            cell.image.image = [UIImage imageNamed:@"addChild"];
            cell.nameLabel.text = @"My Children";
            break;
        case 1:
            cell.image.image = [UIImage imageNamed:@"Vaccines"];
            cell.nameLabel.text = @"Vaccines";
            break;
        case 2:
            cell.image.image = [UIImage imageNamed:@"Nuitrition"];
            cell.nameLabel.text = @"Nutrition";
            break;
        case 3:
            cell.image.image = [UIImage imageNamed:@"Diagnosis"];
            cell.nameLabel.text = @"Diagnosis";
            break;
        case 4:
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
    return 5;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goParentDiagnosis"]) {
        ParentDiagnosisViewController *vc = (ParentDiagnosisViewController *)segue.destinationViewController;
        vc.mode = E_ParentDiagnosis_MyChildren;
    }
}

- (IBAction)unwindToParentMain:(UIStoryboardSegue *)segue{
    
}

@end
