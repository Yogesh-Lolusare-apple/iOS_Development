//
//  TSPara_Question.h
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSPara_Question : NSObject

@property (nonatomic, retain) NSString * t_Question;
@property (nonatomic, retain) NSString * t_CorrectAnswer;
@property (nonatomic, retain) NSString * t_User_Answer;
@property BOOL t_isCorrectAnswer;
@end
 