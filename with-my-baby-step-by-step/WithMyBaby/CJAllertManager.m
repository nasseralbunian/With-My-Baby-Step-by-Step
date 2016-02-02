//
//  CJAllertManager.m
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "CJAllertManager.h"

@implementation CJAllertManager

// The function which shows allert in any controller 
+ (void) presentAllertInController: (UIViewController *) viewController
                              text: (NSString *)text
                           message: (NSString *)message
                             block: (void (^)())block {
    // controller for alert
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle: text
                                          message: message
                                          preferredStyle:UIAlertControllerStyleAlert];
    // ok action for controller
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         block();
                                                     }];
    // add ok action to alert controller
    [alertController addAction:OkAction];
    
    // animate to show
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
