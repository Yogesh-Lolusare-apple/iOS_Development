//
//  UI_HomeScreen.m
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import "UI_HomeScreen.h"
#import "TSServerClass.h"

@interface UI_HomeScreen ()

@end

@implementation UI_HomeScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //CLEARING SERVER DATA 
    TSServerClass* server = [TSServerClass SharedInstance];
    server.t_arrayOfQuestionsAnswers = [NSMutableArray new];
    server.t_numberOfQuestions = 0;
    server.t_UserFName = @"";
    server.t_UserLName = @"";
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
