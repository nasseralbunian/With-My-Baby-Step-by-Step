//
//  Vaccine.h
//  WithMyBaby
//
//  Created by Nasser on 13.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <Parse/Parse.h>


@interface Vaccine : PFObject<PFSubclassing>

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *disease;
@property (retain, nonatomic) NSString *howIsGiven;
@property (retain, nonatomic) NSString *sideEffects;
@property (retain, nonatomic) NSNumber *age;
@property (retain, nonatomic) Vaccine *previousVaccine;
@property (assign, nonatomic) BOOL confirmed;

@end
