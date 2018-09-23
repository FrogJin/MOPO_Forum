//
//  ForumViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-1.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "ForumViewController.h"
#import "UserDatabase.h"
#import "HomepageTableViewController.h"

@interface ForumViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelHideOrShowPassword;

@end

@implementation ForumViewController

sqlite3 *db;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Homepage"])
    {
        HomepageTableViewController *HTVC = segue.destinationViewController;
        HTVC.userName = self.loadUserName;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

- (void)alertBox:(NSString *)caution message:(NSString *)solution;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caution message:solution delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)backgroundTap:(id)sender {
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (IBAction)buttonLogIn:(id)sender {
    self.navigationController.navigationItem.backBarButtonItem.title = @"Back";
    [self performSegueWithIdentifier:@"LogIn" sender:self];
    self.navigationController.topViewController.navigationItem.title = @"LOG IN";
}

- (IBAction)buttonSignUp:(id)sender {
    [self performSegueWithIdentifier:@"SignUp" sender:self];
    self.navigationController.topViewController.navigationItem.backBarButtonItem.title = @"Back";
    self.navigationController.topViewController.navigationItem.title = @"SIGN UP";
}

- (IBAction)buttonConfirm:(id)sender {
    
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    sqlite3_stmt *statement = nil;
    
    //NSString *sqlNull = @".nullvalue NULL";
    //NSString *sqlCreateTable = @"CREATE TABLE USERINFO (userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT)";
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS USERINFO (userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT)";
    //NSString *sqlDropTable = @"DROP TABLE IF EXISTS USERINFO";
    //NSString *sqlClearTable = @"DELETE FROM USERINFO";
    [database execSql:sqlOpenOrCreateTable];
    
    if([self.navigationItem.title isEqualToString: @"LOG IN"])
    {
        NSString *sqlLogIn = [NSString stringWithFormat:@"SELECT * FROM USERINFO WHERE userName = '%@'", self.textUserName.text];
        if (sqlite3_prepare_v2(db, [sqlLogIn UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSString *userPassword = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                if ([self.textPassword.text isEqualToString: userPassword])
                {
                    self.loadUserID = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                    self.loadUserName = self.textUserName.text;
                    [self performSegueWithIdentifier:@"Homepage" sender:self];
                    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
                    NSLog(@"Log In Succesfully");
                } else {
                    [self alertBox:@"Error" message:@"Wrong name or password"];
                    NSLog(@"Wrong Password");
                }
            } else {
                [self alertBox:@"Error" message:@"Wrong name or password"];
                NSLog(@"Account not existed");
            }
        }
        sqlite3_finalize(statement);
        
    } else {
        NSString *sqlCheckAccount = [NSString stringWithFormat:@"SELECT * FROM USERINFO WHERE userName = '%@'", self.textUserName.text];
        if (sqlite3_prepare_v2(db, [sqlCheckAccount UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                if (self.textUserName.text.length >= 6)
                {
                    if (self.textPassword.text.length >= 8)
                    {
                        NSString *sqlSignUp = [NSString stringWithFormat: @"INSERT INTO USERINFO ('userName', 'userPassword') VALUES ('%@', '%@')", self.textUserName.text, self.textPassword.text];
                        [database execSql:sqlSignUp];
                        self.loadUserName = self.textUserName.text;
                        [self performSegueWithIdentifier:@"Homepage" sender:self];
                        [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
                        NSLog(@"Sign Up Successfully");
                    } else {
                        [self alertBox:@"Error" message:@"Password too short (at least 8 characters)"];
                        NSLog(@"Password Too Short");
                    }
                } else {
                    [self alertBox:@"Error" message:@"Username too short (at least 6 characters)"];
                    NSLog(@"Username Too Short");
                }
            } else {
                [self alertBox:@"Error" message:@"This Username has already been used. Please try another one"];
                NSLog(@"Account Existed");
            }
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
    
}

- (IBAction)passwordHideOrShow:(id)sender {
    if (self.textPassword.secureTextEntry == true)
    {
        self.textPassword.secureTextEntry = false;
        self.labelHideOrShowPassword.text = @"             Slide to Hide the Password";
    } else {
        self.textPassword.secureTextEntry = true;
        self.labelHideOrShowPassword.text = @"             Slide to Show the Password";
    }
}

@end
