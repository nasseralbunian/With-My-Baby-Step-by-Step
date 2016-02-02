//
//  AFManager.h
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFClientManagerProtocols.h"

#define Manager [AFClientManager shared]

extern NSString *M_SIGNUP;
extern NSString *M_LOGIN;

// abstract class, to work with the server
@class AFManagerSettings, AFObject;
@interface AFClientManager : NSObject

@property (weak, nonatomic) id<AFClientManagerDelegate> delegate;
@property (weak, nonatomic) id<AFProtocolClientManagerAnalytics> managerAnalytics;
@property (weak, nonatomic) id<AFProtocolClientManagerPushNotifications> managerPushNotifications;

// implementation of the factory pattern:
+ (instancetype)sharedInitWithParaneters: (NSDictionary *)parameters;
+ (instancetype)sharedInitWithSettings: (AFManagerSettings *)settings;
+ (instancetype)shared;  // singleton pattern

// objects methods
- (AFObject *) objectWithClassName:(NSString *) className;
- (void) saveObject:(AFObject *) object;

// users methods
- (void) registrateNewUser: (NSDictionary *) userParameters; // necessarily needs: email, password
- (void) logIn: (NSDictionary *) userParameters; // email, password
- (BOOL) isExistCurrentUser;
- (void) logout;


@end
