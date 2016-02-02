//
//  Doctor.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Doctor.h"

#import <Parse/PFObject+Subclass.h>

@implementation Doctor

@dynamic firstname;
@dynamic lastname;
@dynamic city;
@dynamic dob;
@dynamic min;
@dynamic speciality;
@dynamic confirmed;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Doctor";
}

@end
