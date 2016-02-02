//
//  AFParseSettings.m
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFParseSettings.h"

@implementation AFParseSettings

- (instancetype)init{
    self = [super init];
    if (self) {
        super.type = @"Parse";
    }
    return self;
}

@end
