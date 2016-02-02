
//
//  Nutrition.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Nutrition.h"

#import <Parse/PFObject+Subclass.h>

@implementation Nutrition

@dynamic age;
@dynamic gender;
@dynamic fruits;
@dynamic vegetables;
@dynamic grains;
@dynamic meatsAndBeans;
@dynamic milk;
@dynamic oils;
@dynamic previousNutrition;
@dynamic confirmed;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Nutrition";
}

@end
