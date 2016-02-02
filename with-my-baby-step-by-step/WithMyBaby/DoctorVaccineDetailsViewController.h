//
//  DoctorVaccineDetailsViewController.h
//  WithMyBaby
//
//  Created by Nasser on 16.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@class Vaccine;
@interface DoctorVaccineDetailsViewController : AbstractViewController

@property (weak, nonatomic) Vaccine *vaccine;

@end
