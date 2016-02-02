//
//  Comment.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>

#import "Parent.h"
#import "Vaccine.h"
#import "Nutrition.h"
#import "Complaint.h"

@interface Comment : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) Parent *author;
@property (retain, nonatomic) Vaccine *vaccine;
@property (retain, nonatomic) Nutrition *nutrition;
@property (retain, nonatomic) Complaint *complaint;

@end
