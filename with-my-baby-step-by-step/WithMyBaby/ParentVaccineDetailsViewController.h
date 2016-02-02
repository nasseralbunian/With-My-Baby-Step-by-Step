//
//  ParentVaccineDetailsViewController.h
//  WithMyBaby
//
//  Created by Nasser on 12.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Child, Vaccine;
@interface ParentVaccineDetailsViewController : UIViewController

@property (assign, nonatomic) NSInteger mode;
@property (weak, nonatomic) Child *child;
@property (weak, nonatomic) Vaccine *vaccine;

@end
