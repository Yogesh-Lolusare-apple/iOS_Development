//
//  TSServerClass.h
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSServerClass : NSObject

//GET OBJECT
+(id)SharedInstance;

@property (nonatomic,retain) NSMutableArray* t_arrayOfQuestionsAnswers;
@property (nonatomic,retain) NSString* t_UserFName;
@property (nonatomic,retain) NSString* t_UserLName;
@property int t_numberOfQuestions;

//arc4random_uniform(74)
@end
