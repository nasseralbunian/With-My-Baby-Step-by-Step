//
//  Diagnosis.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>
#import "Complaint.h"
#import "Doctor.h"


@interface Diagnosis : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) Doctor *doctor;
@property (retain, nonatomic) Complaint *complaint;
@property (assign, nonatomic) BOOL moderated;

@end
