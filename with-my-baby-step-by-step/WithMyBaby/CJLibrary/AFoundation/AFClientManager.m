//
//  AFManager.m
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFClientManager.h"
#import "AFObject.h"

#import "AFParseClientManager.h"
#import "AFParseSettings.h"
#import "AFManagerSettings.h"

NSString *M_SIGNUP = @"SIGNUP";
NSString *M_LOGIN = @"LOGIN";


// Abstract class which manages the app-server correlation
@implementation AFClientManager

static AFClientManager *_sharedAFManager = nil;
static dispatch_once_t onceToken;

////////////////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////////////////
+ (instancetype)sharedInitWithParaneters: (NSDictionary *)parameters {
    dispatch_once(&onceToken, ^{
        _sharedAFManager = [[AFClientManager alloc] initWithParaneters:parameters];
    });
    
    return _sharedAFManager;
}


+ (instancetype)sharedInitWithSettings: (AFManagerSettings *)settings{
    dispatch_once(&onceToken, ^{
        _sharedAFManager = [[AFClientManager alloc] initWithSettings: settings];
    });
    
    return _sharedAFManager;
}

+ (instancetype)shared {
    return _sharedAFManager;
}
// Implementation of the fabric pattern
- (instancetype)initWithSettings: (AFManagerSettings *)settings{
    self = [super init];
    if (self) {
        if ([settings.type isEqualToString:@"Parse"]) {
            self = [AFParseClientManager shared];
            AFParseSettings *parseSettings = (AFParseSettings *)settings;
            [[AFParseClientManager shared] initializeWithAppID:parseSettings.applicationID clientKey:parseSettings.clientKey];
        }
    }
    return self;
}

// Implementation of the fabric pattern
- (instancetype)initWithParaneters: (NSDictionary *)parameters{
    self = [super init];
    if (self) {
        if ([parameters[@"type"] isEqualToString:@"Parse"]) {
            _sharedAFManager = [AFParseClientManager shared];
        }
    }
    return self;
}

////////////////////////////////////////////////////////////////////
#pragma mark - Objects methods
////////////////////////////////////////////////////////////////////
- (AFObject *) objectWithClassName:(NSString *) className{ return nil; }
- (void) saveObject:(AFObject *) object{}

////////////////////////////////////////////////////////////////////
#pragma mark - Users methods
////////////////////////////////////////////////////////////////////
- (void) registrateNewUser: (NSDictionary *) userParameters{}
- (void) logIn: (NSDictionary *) userParameters{}
- (BOOL) isExistCurrentUser{ return false; }
- (void) logout{}

@end
