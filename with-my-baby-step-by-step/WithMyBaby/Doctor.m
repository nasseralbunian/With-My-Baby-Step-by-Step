//
//  Doctor.m
//  WithMyBaby
//
//  Created by user on 13.01.16.
//  Copyright © 2016 allmax. All rights reserved.
//

#import "Doctor.h"

#import <Parse/PFObject+Subclass.h>

@implementation Doctor

@dynamic firstname;
@dynamic lastname;
@dynamic DOB;
@dynamic MIN;
@dynamic speciality;
@dynamic confirmed;

+(void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Doctor";
}

@end
