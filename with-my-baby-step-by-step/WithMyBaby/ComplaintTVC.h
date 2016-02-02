//
//  ComplaintTVC.h
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *specializationLabel;
@property (strong, nonatomic) NSDictionary *specialization;

@end
