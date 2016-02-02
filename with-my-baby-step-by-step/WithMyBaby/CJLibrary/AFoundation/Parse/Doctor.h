//
//  Doctor.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>


@interface Doctor : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *firstname;
@property (retain, nonatomic) NSString *lastname;
@property (retain, nonatomic) NSDate *dob;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *min;
@property (retain, nonatomic) NSString *speciality;
@property (assign, nonatomic) BOOL confirmed;


@end


