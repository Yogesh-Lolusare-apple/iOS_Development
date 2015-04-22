//
//  UI_Result.m
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import "UI_Result.h"
#import "TSServerClass.h"
#include "TSPara_Question.h"
@interface UI_Result ()
{
    TSServerClass* server;
    int correctAnsweres;
}
@end

@implementation UI_Result

- (void)viewDidLoad {
    [super viewDidLoad];
    
    server = [TSServerClass SharedInstance];
    
    correctAnsweres = 0;
    
    for(TSPara_Question* para in server.t_arrayOfQuestionsAnswers)
    {
        if(para.t_isCorrectAnswer)
        {
            correctAnsweres++;
        }
    }
    
    self.title = [NSString stringWithFormat:@"Quiz Result: %d / %d",correctAnsweres,server.t_numberOfQuestions];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(goToHomeScreen)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return server.t_arrayOfQuestionsAnswers.count;
}

//#pragma mark CELL
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
  //     cell.backgroundColor = [UIColor greenColor];
  //  cell.textLabel.textColor = [UIColor whiteColor];
    
    TSPara_Question* QuestionAnswer = [server.t_arrayOfQuestionsAnswers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ = %@",QuestionAnswer.t_Question,QuestionAnswer.t_CorrectAnswer];
 
    
   if(QuestionAnswer.t_isCorrectAnswer)
   {
       cell.accessoryType = UITableViewCellAccessoryCheckmark;
   }else
   {
       cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
   }
    
    return cell;
    
}

#pragma mark - LOGICAL METHODS
-(void)goToHomeScreen
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
