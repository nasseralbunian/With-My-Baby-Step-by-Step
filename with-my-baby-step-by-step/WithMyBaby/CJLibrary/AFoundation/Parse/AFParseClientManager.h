//
//  CJParseManager.h
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "AFClientManager.h"

@class AFObject;
// The implementation of the abstract class ClientManager, interacting with Parse.com
@interface AFParseClientManager : AFClientManager<AFProtocolClientManagerAnalytics, AFProtocolClientManagerPushNotifications>

// init
+ (instancetype)shared; // singleton pattern

// parse init
- (void) initializeWithAppID: (NSString *) appID clientKey: (NSString *) clientKey;

// objects methods
- (AFObject *) objectWithClassName:(NSString *) className;
- (void) saveObject:(AFObject *) object;

// users methods
- (void) registrateNewUser: (NSDictionary *) userParameters; // necessarily needs: email, password
- (void) logIn: (NSDictionary *) userParameters; // email, password
- (BOOL) isExistCurrentUser;
- (void) logout;

// AFProtocolClientManagerAnalytics
- (void) startAnalyticsWithOptions: (NSDictionary *)launchOptions;

// AFProtocolClientManagerPushNotifications
- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo applicationState: (UIApplicationState) applicationState;

@end
