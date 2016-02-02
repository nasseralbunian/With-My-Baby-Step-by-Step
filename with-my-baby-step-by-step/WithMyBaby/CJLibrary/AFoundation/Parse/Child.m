//
//  Child.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Child.h"

#import <Parse/PFObject+Subclass.h>

@implementation Child

@dynamic parent;
@dynamic name;
@dynamic gender;
@dynamic weight;
@dynamic dob;
@dynamic takenVaccines;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Child";
}

@end
