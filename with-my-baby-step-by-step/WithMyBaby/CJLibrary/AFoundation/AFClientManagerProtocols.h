//
//  AFManagerProtocols.h
//  WithMyBaby
//
//  Created by Nasser on 11.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#ifndef AFManagerProtocols_h
#define AFManagerProtocols_h

#import <UIKit/UIKit.h>

@class AFClientManager;
// main protocol client manager class
@protocol AFClientManagerDelegate <NSObject>

@optional
- (void)manager: (AFClientManager *) manager
        request: (NSString *) requestName
          error: (NSString *)error
        results: (id) results;

@end

// protocol to support Push Notifications
@protocol AFProtocolClientManagerPushNotifications <NSObject>

- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo applicationState: (UIApplicationState) applicationState;

@end

// protocol to support Analytics
@protocol AFProtocolClientManagerAnalytics <NSObject>

- (void) startAnalyticsWithOptions: (NSDictionary *)launchOptions;

@end


#endif /* AFManagerProtocols_h */
