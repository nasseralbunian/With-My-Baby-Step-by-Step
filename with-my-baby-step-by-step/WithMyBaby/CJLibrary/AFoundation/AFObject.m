//
//  AFObject.m
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFObject.h"

// abstract class object that is stored on the server
@implementation AFObject

+ (AFObject *) objectWithClassName: (NSString *)className{ return nil; }
- (void) save{}

// fields
- (void)setValue:(id)value forKey:(NSString *)key{}
- (id)valueForKey:(NSString *)key{ return nil; }
- (id)value{ return nil; }

@end
