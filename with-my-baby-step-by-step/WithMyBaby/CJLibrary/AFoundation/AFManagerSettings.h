//
//  AFManagerSettings.h
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

// abstract class parameters required to initialize ClientManager, supporting one or another server (Parse.com for example)
@interface AFManagerSettings : NSObject

@property (strong, nonatomic) NSString *type;

@end
