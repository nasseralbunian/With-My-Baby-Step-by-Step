//
//  Doctor.h
//  WithMyBaby
//
//  Created by user on 13.01.16.
//  Copyright © 2016 allmax. All rights reserved.
//

#import <Parse/Parse.h>

@interface Doctor : PFObject<PFSubclassing>

@property (retain) NSString *firstname;
@property (retain) NSString *lastname;
@property (retain) NSString *DOB;
@property (retain) NSString *MIN;
@property (retain) NSString *speciality;
@property (retain) NSNumber *confirmed;

+ (NSString *)parseClassName;

@end


