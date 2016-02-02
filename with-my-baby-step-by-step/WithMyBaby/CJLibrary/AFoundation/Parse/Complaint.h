//
//  Complaint.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>
#import "Child.h"


@interface Complaint : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSString *speciality;
@property (assign, nonatomic) NSInteger status; // 0 - "new", 1 - "open", 2 - "close"
@property (retain, nonatomic) Child *child;

@end
