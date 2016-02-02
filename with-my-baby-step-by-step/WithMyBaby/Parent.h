//
//  Parent.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>


@interface Parent : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *firstname;
@property (retain, nonatomic) NSString *lastname;
@property (retain, nonatomic) NSDate *dob;
@property (retain, nonatomic) NSString *city;
@property (assign, nonatomic) BOOL confirmed;

@end
