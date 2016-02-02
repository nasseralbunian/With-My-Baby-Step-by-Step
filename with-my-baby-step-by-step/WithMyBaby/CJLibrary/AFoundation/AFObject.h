//
//  AFObject.h
//  WithMyBaby
//
//  Created by Nasser on 07.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

// abstract class object that is stored on the server
@interface AFObject : NSObject

+ (AFObject *) objectWithClassName: (NSString *)className; 
- (void) save;

// methods for fields
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (id)value;

@end
