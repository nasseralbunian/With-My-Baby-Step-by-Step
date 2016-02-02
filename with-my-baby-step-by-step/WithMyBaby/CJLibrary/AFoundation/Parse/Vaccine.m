//
//  Vaccine.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Vaccine.h"

#import <Parse/PFObject+Subclass.h>

@implementation Vaccine

@dynamic name;
@dynamic sideEffects;
@dynamic age;
@dynamic confirmed;
@dynamic disease;
@dynamic howIsGiven;
@dynamic previousVaccine;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Vaccine";
}

@end
