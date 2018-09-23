//
//  SignUpViewController.m
//  MOPO Forum V1.0
//
//  Created by 城投物业 on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SignUpViewController.h"
#import "SQLiteDatabase.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelRePassword;
@property (weak, nonatomic) IBOutlet UILabel *labelInvitationCode;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textRePassword;
@property (weak, nonatomic) IBOutlet UITextField *textInvitationCode;

@end

@implementation SignUpViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

- (IBAction)backgroundTap:(id)sender {
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (IBAction)buttonConfirm:(id)sender {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database openOrCreateDatabase:@"UserInfo"];
    sqlite3 *db;
    sqlite3_stmt *statement = nil;
    if (self.textUserName.text.length >=6){
        if (self.textPassword.text.length >=8){
            if ([self.textRePassword.text isEqualToString:self.textPassword.text]){
                if ([self.textInvitationCode.text isEqualToString:@""]) {
                    
                    [database openOrCreateTable:@"Accounts"
                               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT"];
                    NSString *sqlCheckAccount = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", self.textUserName.text];
                    
                    if (sqlite3_prepare_v2(db, [sqlCheckAccount UTF8String], -1, &statement, NULL) == SQLITE_OK){
                        if (sqlite3_step(statement) == SQLITE_DONE){
                            [database insertAttributes:[NSString stringWithFormat:@"%@, %@, public", self.textUserName.text, self.textPassword.text]
                                       forDescriptions:@"'userName', 'userPassword', 'accountType'"
                                             intoTable:@"Accounts"];
                        } else {
                            [database alertBox:@"Error"
                                       message:@"This Username has already been used. Please try another one"
                              withCancelButton:@"OK"
                                andOtherButton:nil];
                        }
                    }
                    
                } else {
                    
                    [database openOrCreateTable:@"InvitationCode"
                               withDescriptions:@"codeID INTEGER PRIMARY KEY, code TEXT, codeType TEXT"];
                    NSString *sqlCheckCode = [NSString stringWithFormat:@"SELECT * FROM InvitationCode WHERE code = '%@'", self.textInvitationCode.text];
                    
                    if (sqlite3_prepare_v2(db, [sqlCheckCode UTF8String], -1, &statement, NULL) == SQLITE_OK){
                        if (sqlite3_step(statement) != SQLITE_DONE){
                            NSString *accountType = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                            [database insertAttributes:[NSString stringWithFormat:@"%@, %@, %@", self.textUserName, self.textPassword, accountType]
                                       forDescriptions:@"'userName', 'userPassword', 'accountType'"
                                             intoTable:@"Accounts"];
                            [database deleteAttributes:@"*"
                                       withRequirement:[NSString stringWithFormat:@"'code = %@'", self.textInvitationCode.text]
                                             fromTable:@"InvitationCode"];
                            
                        } else {
                            [database alertBox:@"Error"
                                       message:@"Invalid Invitation Code"
                              withCancelButton:@"OK"
                                andOtherButton:nil];
                        }
                    }
                    
                }
            } else {
                [database alertBox:@"Error"
                           message:@"Password and Re-Password do not match, Please try again"
                  withCancelButton:@"OK"
                    andOtherButton:nil];
            }
        } else {
            [database alertBox:@"Error"
                       message:@"Password too short (at least 8 characters)"
              withCancelButton:@"OK"
                andOtherButton:nil];
        }
    } else {
        [database alertBox:@"Error"
                   message:@"Username too short (at least 6 characters)"
          withCancelButton:@"OK"
            andOtherButton:nil];
    }
}

@end
