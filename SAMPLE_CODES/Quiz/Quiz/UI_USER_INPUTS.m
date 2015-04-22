//
//  UI_USER_INPUTS.m
//  Quiz
//
//  Created by Tacktile Systems on 22/04/15.
//  Copyright (c) 2015 YOYO. All rights reserved.
//

#import "UI_USER_INPUTS.h"
#import "TSServerClass.h"
@interface UI_USER_INPUTS ()
{
    BOOL moved;
}
@end

@implementation UI_USER_INPUTS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"User Details";
    
    //UI Moveds
    moved = FALSE;
    
    
    //TAp GEsture to close keyboard    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gesture];
    
    //GET TOOLBAR for TEXTFIELDS
    self.textField_Fname.inputAccessoryView =  [self getToolbar :0];
    self.textField_Lname.inputAccessoryView =  [self getToolbar :1];
    self.textField_NumberOfQuestions.inputAccessoryView =  [self getToolbar :2];
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
#pragma mark - START QUIZ

- (IBAction)action_StartQuiz:(id)sender {
    
    
    if(self.textField_Fname.text.length > 0 && self.textField_Lname.text.length > 0 && self.textField_NumberOfQuestions.text.length > 0)
    {
        TSServerClass* server = [TSServerClass SharedInstance];
        server.t_UserFName = self.textField_Fname.text;
        server.t_UserLName = self.textField_Lname.text;
        server.t_numberOfQuestions = (int)[self.textField_NumberOfQuestions.text integerValue];
        
        [self performSegueWithIdentifier:@"segueQuiz" sender:self];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Please fill all details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - KEYBOARD & TOOLBAR DELEGATS
-(UIToolbar*)getToolbar :(int)tagNumber
{
    UIToolbar* keyboardToolbar;
    
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *next;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    
    
    if(tagNumber != 2)
    {
        next   = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextTextField:)];
        next.tag = tagNumber;
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: done,extraSpace, next, nil]];
    }else
    {
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace,done, nil]];
    }
    
    
    return keyboardToolbar;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    if(moved) {
        [self animateViewToPosition:self.view directionUP:NO];
    }
    moved = NO;
}
-(void)nextTextField :(UIBarButtonItem*)sender
{
    if(sender.tag == 0)
    {
        [self.textField_Lname becomeFirstResponder];
    } else if(sender.tag == 1)
    {
        [self.textField_NumberOfQuestions becomeFirstResponder];
    }else if(sender.tag == 2)
    {
        [self dismissKeyboard];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField.tag == 2){
    if(!moved) {
        [self animateViewToPosition:self.view directionUP:YES];
        moved = YES;
    }
        
    }
    
}



-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up
{
    
    const int movementDistance = -135; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}
@end
