//
//  UI_TEST.h
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UI_TEST : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_Question;
@property (weak, nonatomic) IBOutlet UITextField *textField_Answer;
- (IBAction)action_NextQuestion:(id)sender;

@end
