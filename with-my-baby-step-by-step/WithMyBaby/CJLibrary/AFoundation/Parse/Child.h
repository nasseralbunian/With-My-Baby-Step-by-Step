//
//  Child.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>

#import "Parent.h"


@interface Child : PFObject<PFSubclassing>

@property (retain, nonatomic) Parent *parent;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL gender;
@property (retain, nonatomic) NSNumber *weight;
@property (retain, nonatomic) NSDate *dob;
@property (retain, nonatomic) NSArray *takenVaccines;

@end
