//
//  ParentVaccinesTVC.h
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VaccinesTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRangeLabel;

@end
