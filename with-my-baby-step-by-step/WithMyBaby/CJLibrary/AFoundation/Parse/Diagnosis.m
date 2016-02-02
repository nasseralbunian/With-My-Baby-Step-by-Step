//
//  Diagnosis.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Diagnosis.h"

#import <Parse/PFObject+Subclass.h>

@implementation Diagnosis

@dynamic text;
@dynamic date;
@dynamic doctor;
@dynamic complaint;
@dynamic moderated;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Diagnosis";
}

@end
