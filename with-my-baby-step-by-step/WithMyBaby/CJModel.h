//
//  CJModel.h
//  WithMyBaby
//
//  Created by Nasser on 29.12.15.
//  Copyright © 2015 Nasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CJLibrary.h"
#import "AFoundation.h"

#import "Comment.h"
#import "Diagnosis.h"

#define myNotificationNameChangeData @"kChangeData"

#define Model [CJModel shared]

extern NSString *C_Parent;
extern NSString *C_Doctor;
extern NSString *C_Confirmed;

typedef enum : NSUInteger {
    E_Vaccine_Due = 0,
    E_Vaccine_Future = 1,
    E_Vaccine_Past = 2
} E_Vaccine;

typedef enum : NSUInteger {
    E_Message_New = 0,
    E_Message_Open = 1,
    E_Message_Close = 2
} E_Message;

@class CJModel;
@protocol CJModelDelegate <NSObject>

@optional
- (void) model: (CJModel *)model changeChildren: (NSArray *)children;

@end

// Global model class. Caches data from the server of the user objects Parent, Doctor, an array of objects Child
@interface CJModel : NSObject

@property (strong, nonatomic, readonly) Parent *parent;
@property (strong, nonatomic, readonly) NSArray *children;
@property (strong, nonatomic, readonly) Doctor *doctor;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic, readonly) NSArray *specializations;

@property (weak, nonatomic) id <CJModelDelegate> delegate;

+ (instancetype)shared; // singleton pattern

- (void) reloadChildren;
- (void) reset;

- (NSString *) complaintStatus: (NSInteger) status;
- (NSString *) md5hash: (NSString *)string;

@end
