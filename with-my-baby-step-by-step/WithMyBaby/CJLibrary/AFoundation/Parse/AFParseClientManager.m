//
//  CJParseManager.m
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "AFParseClientManager.h"
#import "AFParseObject.h"

@import Parse;

// The implementation of the abstract class ClientManager, interacting with Parse.com
@implementation AFParseClientManager

////////////////////////////////////////////////////////////////////
#pragma mark - init
////////////////////////////////////////////////////////////////////

// Implementation of the singleton pattern
+ (instancetype)shared {
    static AFParseClientManager *_sharedParseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedParseManager = [[AFParseClientManager alloc] init];
    });
    
    return _sharedParseManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.managerAnalytics = self;
        self.managerPushNotifications = self;
    }
    return self;
}

- (void) initializeWithAppID: (NSString *) appID clientKey: (NSString *) clientKey{
    [Parse enableLocalDatastore];
    [Parse setApplicationId:appID clientKey:clientKey];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Objects methods
////////////////////////////////////////////////////////////////////
- (AFObject *) objectWithClassName:(NSString *) className{
    return [AFParseObject objectWithClassName:className];
}

- (void) saveObject:(AFObject *) object{
    [object save];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Users methods
////////////////////////////////////////////////////////////////////

// Registration of the user on the Parse.com
- (void) registrateNewUser: (NSDictionary *) userParameters{
    // create new user
    PFUser *user = [PFUser user];
    
    NSArray *keys = userParameters.allKeys;
    
    // create all fields from userParameters
    BOOL isExistUsername = NO;
    for (NSString *key in keys) {
        user[key] = userParameters[key];
        if ([key isEqualToString:@"username"]) {
            isExistUsername = YES;
        }
    }
    // username field is a copy email field
    if (!isExistUsername) {
        user[@"username"] = userParameters[@"email"];
    }
    
    // user`s sign up
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(manager:request:error:results:)]) {
                [self.delegate manager:self
                               request:M_SIGNUP
                                 error:nil
                               results:nil];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(manager:request:error:results:)]) {
                [self.delegate manager:self
                               request:M_SIGNUP
                                 error:error.userInfo[@"error"]
                               results:error];
            }
        }
    }];
}


// Authorization of the user on the Parse.com
- (void) logIn: (NSDictionary *) userParameters{
    [PFUser logInWithUsernameInBackground:userParameters[@"username"] password:userParameters[@"password"]
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            if ([self.delegate respondsToSelector:@selector(manager:request:error:results:)]) {
                                                [self.delegate manager:self
                                                               request:M_LOGIN
                                                                 error:nil
                                                               results:user];
                                            }
                                        } else {
                                            if ([self.delegate respondsToSelector:@selector(manager:request:error:results:)]) {
                                                [self.delegate manager:self
                                                               request:M_LOGIN
                                                                 error:error.userInfo[@"error"]
                                                               results:error];
                                            }
                                        }
                                    }];
}

- (BOOL) isExistCurrentUser{
    return PFUser.currentUser ? YES : NO;
}

- (void) logout{
    [PFUser logOut];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Manager Analytics
////////////////////////////////////////////////////////////////////
- (void) startAnalyticsWithOptions: (NSDictionary *)launchOptions{
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

////////////////////////////////////////////////////////////////////
#pragma mark - Manager Push Notifications
////////////////////////////////////////////////////////////////////

// The function which is derived when the remote notification is recieved
- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo applicationState: (UIApplicationState) applicationState{
    [PFPush handlePush:userInfo];
    
    if (applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

// The function which is derived when the remote notification is registrated
- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }];
}

@end
