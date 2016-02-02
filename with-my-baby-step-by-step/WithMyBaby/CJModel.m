//
//  CJModel.m
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import "CJModel.h"
#import "NSString+TBEncryption.h"

NSString *C_Parent = @"parent";
NSString *C_Doctor = @"doctor";
NSString *C_Confirmed = @"confirmed";

// The app model class
@implementation CJModel

////////////////////////////////////////////////////////////////////
#pragma mark - init
////////////////////////////////////////////////////////////////////

// Implementation of the singleton pattern
+ (instancetype)shared {
    static CJModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[CJModel alloc] init];
    });
    
    return _sharedModel;
}

// The function initiates the internal components of the class
- (instancetype)init{
    self = [super init];
    if (self) {
        [self reset];
        
        _specializations = @[@{@"name" : @"General paediatrics consultant",
                               @"bodyPart"  : @"General diagnosis"},
                             @{@"name" : @"Paediatric Audiologist",
                               @"bodyPart"  : @"Ears"},
                             @{@"name" : @"Paediatric Cardiologist",
                               @"bodyPart"  : @"Heart"},
                             @{@"name" : @"Paediatric Desntist",
                               @"bodyPart"  : @"Teeth"},
                             @{@"name" : @"Paediatric Dermatologist",
                               @"bodyPart"  : @"Hair, Nails, and Skin"},
                             @{@"name" : @"Paediatric Gastroenterologist",
                               @"bodyPart"  : @"Stomach and Digestive"},
                             @{@"name" : @"Paediatric Nephrologist",
                               @"bodyPart"  : @"Kidney"},
                             @{@"name" : @"Paediatric Ophthalmologist",
                               @"bodyPart"  : @"Eyes"},
                             @{@"name" : @"Paediatric Orthopaedic",
                               @"bodyPart"  : @"Bones"},
                             @{@"name" : @"Paediatric Thoracic",
                               @"bodyPart"  : @"Lungs and Chest"},
                             @{@"name" : @"Paediatric Allergist",
                               @"bodyPart"  : @"Allergies"},
                             @{@"name" : @"Paediatric Neurologist",
                               @"bodyPart"  : @"Neurology"},
                             @{@"name" : @"Paediatric Psychiatrist",
                               @"bodyPart"  : @"Psychological Diseases"}];
    }
    return self;
}

////////////////////////////////////////////////////////////////////
#pragma mark - Setters / Getters
////////////////////////////////////////////////////////////////////
- (void)setUser:(PFUser *)user{
    _user = user;
    
    [self reset];
}

- (NSString *) complaintStatus: (NSInteger) status{
    switch (status) {
        case 1:
            return @"Open";
        case 2:
            return @"Close";
    }
    return @"New";
}

////////////////////////////////////////////////////////////////////
#pragma mark - Other functions
////////////////////////////////////////////////////////////////////

// The function sends the request to the server and receive the array of the child class
- (void) reloadChildren{
    // get children list from server
    PFQuery * query = [Child query];
    [query whereKey:@"parent" equalTo:_parent];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        
        _children = objects;
        if ([_delegate respondsToSelector:@selector(model:changeChildren:)]) {
            [_delegate model:self changeChildren:objects];
        }
    }];
}

- (NSString *) md5hash: (NSString *)string{
    NSString *prefix = @"WithMyBaby";
    
    return [[NSString stringWithFormat:@"%@%@%@", prefix, string, prefix] tb_MD5String];
}
////////////////////////////////////////////////////////////////////
#pragma mark - save
////////////////////////////////////////////////////////////////////

//The function of the full data reset
- (void) reset{
    // create parent object
    _parent = [PFUser currentUser][C_Parent];
    // if parent exists
    if (_parent) {
        [_parent fetchIfNeededInBackgroundWithBlock:^(PFObject * object, NSError * error) {
            if (error) {
                NSLog(@"some error");
                return;
            }
            
            _parent = (Parent *)object;
        }];
        
        // create childs array
        [self reloadChildren];
    }
    
    // create doctor object
    _doctor = [PFUser currentUser][C_Doctor];
    // if doctor exists
    if (_doctor) {
        [_doctor fetchIfNeededInBackgroundWithBlock:^(PFObject * object, NSError * error) {
            if (error) {
                NSLog(@"some error");
                return;
            }
            
            _doctor = (Doctor *)object;
        }];
    }
}

@end
