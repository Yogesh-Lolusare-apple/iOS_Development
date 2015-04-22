//
//  TSServerClass.m
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import "TSServerClass.h"
static TSServerClass *sharedInstance = nil;

@implementation TSServerClass
#pragma mark -
#pragma mark SingeltonObjectOfServerClass
+(id)SharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
        
        //  database = [TSDatabaseInteraction new];
        //  networking = [TSNetworking new];
    });
       
    return sharedInstance;
    
}

@synthesize t_arrayOfQuestionsAnswers,t_numberOfQuestions,t_UserFName,t_UserLName;
@end
