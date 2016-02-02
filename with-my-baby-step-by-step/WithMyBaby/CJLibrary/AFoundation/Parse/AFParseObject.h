//
//  CJParseObject.h
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFObject.h"

// class object that is stored on the Parse.com
@interface AFParseObject : AFObject

+ (AFObject *) objectWithClassName: (NSString *)className;
- (void) save;

// methods for fields
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (id)value;

@end
