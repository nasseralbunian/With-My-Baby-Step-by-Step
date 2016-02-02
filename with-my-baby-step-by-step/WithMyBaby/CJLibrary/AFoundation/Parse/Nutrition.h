//
//  Nutrition.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>


@interface Nutrition : PFObject<PFSubclassing>

@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) NSInteger gender;
@property (retain, nonatomic) NSString *fruits;
@property (retain, nonatomic) NSString *vegetables;
@property (retain, nonatomic) NSString *grains;
@property (retain, nonatomic) NSString *meatsAndBeans;
@property (retain, nonatomic) NSString *milk;
@property (retain, nonatomic) NSString *oils;
@property (retain, nonatomic) Nutrition *previousNutrition;
@property (assign, nonatomic) BOOL confirmed;

@end
