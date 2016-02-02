//
//  Parent.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Parent.h"

#import <Parse/PFObject+Subclass.h>

@implementation Parent

@dynamic firstname;
@dynamic lastname;
@dynamic dob;
@dynamic city;
@dynamic confirmed;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Parent";
}

@end
