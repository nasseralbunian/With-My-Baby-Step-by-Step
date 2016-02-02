//
//  NSString+CJString.m
//  WithMyBaby
//
//  Created by Nasser on 04.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import "NSString+CJString.h"

@implementation NSString (CJString)

-(BOOL) isValidEmail{
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", laxString];
    return [emailTest evaluateWithObject:self];
}

@end
