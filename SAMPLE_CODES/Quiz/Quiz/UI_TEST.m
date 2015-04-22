//
//  UI_TEST.m
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import "UI_TEST.h"
#import "TSServerClass.h"
#import "TSPara_Question.h"
@interface UI_TEST ()
{
    TSServerClass* server;
    int questionCounter;
    NSArray* arrayOfOperations;
}
@end

@implementation UI_TEST

- (void)viewDidLoad {
    [super viewDidLoad];
    
      server = [TSServerClass SharedInstance];
    questionCounter = 0;
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"Quiz for %@",server.t_UserFName];
    
    arrayOfOperations = [[NSArray alloc] initWithObjects:@"*",@"+",@"-", nil];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"End Quiz" style:UIBarButtonItemStylePlain target:self action:@selector(goToHomeScreen)];
    
    //TAp GEsture to close keyboard
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gesture];
        self.navigationItem.leftBarButtonItem = backButton;
    
    //DISPLAY QUESTION
    [self CreateQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ACTION
- (IBAction)action_NextQuestion:(id)sender {
    
    if(self.textField_Answer.text.length > 0){
    
        //CATCHINHG USER ANSWER
        TSPara_Question* questionAnswer = [server.t_arrayOfQuestionsAnswers lastObject];
        questionAnswer.t_User_Answer = self.textField_Answer.text;
        if([questionAnswer.t_User_Answer isEqualToString:questionAnswer.t_CorrectAnswer])
        {
            questionAnswer.t_isCorrectAnswer = TRUE;
        }else
        {
            questionAnswer.t_isCorrectAnswer = FALSE;
        }
        
        [server.t_arrayOfQuestionsAnswers replaceObjectAtIndex:server.t_arrayOfQuestionsAnswers.count - 1 withObject:questionAnswer];
        
          //CATCHINHG USER ANSWER
    if([self CreateQuestion])
    {
        
        
    }else{
    //NUMBER OF QUESTION's Completed
    [self performSegueWithIdentifier:@"segueResult" sender:self];
    }
    }else
    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Please answer the question." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - LOGICAL METHODS
-(void)goToHomeScreen
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
  
}

-(BOOL)CreateQuestion
{
    self.textField_Answer.text = @"";
    
    if(questionCounter < server.t_numberOfQuestions)
    {
        questionCounter ++;
        
        int Number1 = arc4random_uniform(50);
        int Number2 = arc4random_uniform(50);
        NSString* operator =  [arrayOfOperations objectAtIndex:arc4random_uniform(10)%3];
        

        
        TSPara_Question* questionAnswer = [TSPara_Question new];
       
        
        if([operator isEqualToString:@"*"])
        {
            questionAnswer.t_CorrectAnswer =[NSString stringWithFormat:@"%d",Number1 * Number2];
        }else if ([operator isEqualToString:@"+"])
        {
              questionAnswer.t_CorrectAnswer =[NSString stringWithFormat:@"%d",Number1 + Number2];
        }else if ([operator isEqualToString:@"-"])
        {
            // for case  25 - 50
            if (Number2 > Number1) {
                int temp = Number2;
                Number2 = Number1;
                Number1 = temp;
            }
            // for case  25 - 50
              questionAnswer.t_CorrectAnswer =[NSString stringWithFormat:@"%d",Number1 - Number2];
        }
                self.label_Question.text = [NSString stringWithFormat:@"Question Number %d:\n What is %d %@ %d ?",questionCounter,Number1,operator,Number2];
         questionAnswer.t_Question = [NSString stringWithFormat:@"%d %@ %d",Number1,operator,Number2];
        [server.t_arrayOfQuestionsAnswers addObject:questionAnswer];
       
     
        return TRUE;
    }else
    {
        return FALSE;
    }
}

@end
