//
//  ParentDiagnosisViewController.h
//  WithMyBaby
//
//  Created by user on 12.01.16.
//  Copyright © 2016 allmax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    E_ParentDiagnosis_MyChildren,
    E_ParentDiagnosis_Experience_Parent,
    E_ParentDiagnosis_Experience_Doctor
} E_ParentDiagnosis;

@interface ParentDiagnosisViewController : UIViewController

@property (assign, nonatomic) E_ParentDiagnosis mode;

@end
