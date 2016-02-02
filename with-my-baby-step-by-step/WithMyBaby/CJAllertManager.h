//
//  CJAllertManager.h
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJAllertManager : NSObject

+ (void) presentAllertInController: (UIViewController *) viewController
                              text: (NSString *)text
                           message: (NSString *)message
                             block: (void (^)())block;

@end
