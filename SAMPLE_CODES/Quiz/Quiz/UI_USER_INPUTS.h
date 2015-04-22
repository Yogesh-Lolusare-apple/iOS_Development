//
//  UI_USER_INPUTS.h
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UI_USER_INPUTS : UIViewController <UITextFieldDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField_Fname;
@property (weak, nonatomic) IBOutlet UITextField *textField_Lname;
@property (weak, nonatomic) IBOutlet UITextField *textField_NumberOfQuestions;
- (IBAction)action_StartQuiz:(id)sender;

@end
