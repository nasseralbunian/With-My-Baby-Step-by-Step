//
//  AFParseSettings.h
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "AFManagerSettings.h"

@interface AFParseSettings : AFManagerSettings

- (instancetype)init;

@property (strong, nonatomic) NSString *applicationID;
@property (strong, nonatomic) NSString *clientKey;

@end
