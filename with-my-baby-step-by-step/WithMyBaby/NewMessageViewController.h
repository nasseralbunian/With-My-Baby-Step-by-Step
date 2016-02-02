//
//  NewMessageViewController.h
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    E_NewMessage_NewComplaint = 0x0,
    E_NewMessage_NewDiagnosis = 0x1,
    E_NewMessage_NewComment = 0x2,
} E_NewMessage;

@class Child, Complaint;
@interface NewMessageViewController : UIViewController

@property (weak, nonatomic) NSDictionary *specialization;
@property (weak, nonatomic) Child *child;
@property (assign, nonatomic) E_NewMessage mode;
@property (weak, nonatomic) Complaint *complaint;

@end
