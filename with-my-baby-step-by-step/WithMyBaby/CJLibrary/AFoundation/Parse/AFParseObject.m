//
//  CJParseObject.m
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFParseObject.h"


@import Parse;

@interface AFParseObject (){
    PFObject *object;
}

@end

// class object that is stored on the Parse.com
@implementation AFParseObject

////////////////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////////////////
+ (AFObject *) objectWithClassName: (NSString *)className{
    AFParseObject *object = [[AFParseObject alloc] initWithClassName:className];
    return object;
}

- (instancetype)initWithClassName: (NSString *)className{
    self = [super init];
    if (self) {
        object = [PFObject objectWithClassName:className];
    }
    return self;
}

////////////////////////////////////////////////////////////////////
#pragma mark - Save
////////////////////////////////////////////////////////////////////
- (void) save{
    [object saveInBackground];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Fields
////////////////////////////////////////////////////////////////////

- (void)setValue:(id)value forKey:(NSString *)key{
    object[key] = value;
}

- (id)valueForKey:(NSString *)key{
    return object[key];
}

- (id)value{
    return object;
}
@end
