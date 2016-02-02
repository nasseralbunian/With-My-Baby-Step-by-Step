//
//  Comment.m
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "Comment.h"

#import <Parse/PFObject+Subclass.h>

@implementation Comment

@dynamic text;
@dynamic date;
@dynamic author;
@dynamic vaccine;
@dynamic nutrition;
@dynamic complaint;

+ (void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Comment";
}

@end
