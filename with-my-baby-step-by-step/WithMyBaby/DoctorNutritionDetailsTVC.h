//
//  DoctorNutritionDetailsTVC.h
//  WithMyBaby
//
//  Created by Nasser on 15.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

// Table View Cell of doctor nutrition details
@interface DoctorNutritionDetailsTVC : UITableViewCell

// Label that shows the food group
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// Label that shows the size of daily serving
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

// Label that shows the daily serving
@property (weak, nonatomic) IBOutlet UITextField *dailyServingTextField;

@end
