//
//  LogInViewController.m
//  MOPO Forum V1.0
//
//  Created by 城投物业 on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelHideOrShowPassword;

@end

@implementation LogInViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

- (IBAction)backgroundTap:(id)sender {
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (IBAction)passwordHideOrShow:(id)sender {
    if (self.textPassword.secureTextEntry == true)
    {
        self.textPassword.secureTextEntry = false;
        self.labelHideOrShowPassword.text = @"Slide to Hide the Password";
    } else {
        self.textPassword.secureTextEntry = true;
        self.labelHideOrShowPassword.text = @"Slide to Show the Password";
    }
}

@end
