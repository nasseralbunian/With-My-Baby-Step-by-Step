//
//  ChatViewController.h
//  WithMyBaby
//
//  Created by Nasser on 20.01.16.
//  Copyright © 2016 Nasser. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    E_Chat_Parent,
    E_Chat_Parent_Viewer,
    E_Chat_Doctor
} E_Chat;

typedef enum : NSUInteger {
    E_ChatMessage_All,
    E_ChatMessage_ConfirmedOnly
} E_ChatMessage;

@class Complaint;
@interface ChatViewController : UIViewController

@property (assign, nonatomic) E_Chat mode;
@property (assign, nonatomic) E_ChatMessage messageMode;
@property (weak, nonatomic) Complaint *complaint;

@end
