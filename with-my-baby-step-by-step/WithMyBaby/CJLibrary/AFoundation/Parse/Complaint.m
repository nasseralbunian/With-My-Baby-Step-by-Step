//
//  Complaint.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Complaint.h"

#import <Parse/PFObject+Subclass.h>

@implementation Complaint

@dynamic text;
@dynamic date;
@dynamic speciality;
@dynamic status;
@dynamic child;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Complaint";
}

@end
