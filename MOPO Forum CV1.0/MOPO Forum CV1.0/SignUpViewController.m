//
//  SignUpViewController.m
//  MOPO Forum V1.0
//
//  Created by Tim Jin on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SignUpViewController.h"
#import "MasterHomepageTableViewController.h"
#import "VolunteerHomepageTableViewController.h"
#import "PublicHomepageTableViewController.h"
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
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;

@end

@implementation SignUpViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    [self.buttonConfirm setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4]];
}

- (IBAction)backgroundTap:(id)sender {
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
    [self.textRePassword resignFirstResponder];
    [self.textInvitationCode resignFirstResponder];
}

#pragma mark - IBAction

- (IBAction)buttonConfirm:(id)sender {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database openOrCreateDatabase:@"UserInfo"];
    sqlite3_stmt *statement = nil;
    
    if (self.textUserName.text.length >=6){
        if (self.textPassword.text.length >=8){
            if ([self.textRePassword.text isEqualToString:self.textPassword.text]){
                if ([self.textInvitationCode.text isEqualToString:@""]) {
                    
                    [database openOrCreateTable:@"Accounts"
                               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
                    NSString *sqlCheckAccount = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", self.textUserName.text];
                    
                    if (sqlite3_prepare_v2(db, [sqlCheckAccount UTF8String], -1, &statement, NULL) == SQLITE_OK){
                        if (sqlite3_step(statement) == SQLITE_DONE){
                            
                            [database insertAttributes:[NSString stringWithFormat:@"'%@', '%@', 'public'", self.textUserName.text, self.textPassword.text]
                                       forDescriptions:@"'userName', 'userPassword', 'accountType'"
                                             intoTable:@"Accounts"];
                            
                            PublicHomepageTableViewController *PHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PublicHomepage"];
                            PHTVC.title = @"公共主页";
                            PHTVC.loadedUserName = self.textUserName.text;
                            [self.navigationController pushViewController:PHTVC animated:YES];
                            PHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                            
                        } else {
                            [database alertBox:@"错误"
                                       message:@"该用户名已被使用"
                              withCancelButton:@"确认"];
                        }
                    }
                    
                } else {
                    
                    [database openOrCreateTable:@"InvitationCode"
                               withDescriptions:@"codeID INTEGER PRIMARY KEY, code TEXT, codeType TEXT"];
                    NSString *sqlCheckCode = [NSString stringWithFormat:@"SELECT * FROM InvitationCode WHERE code = '%@'", self.textInvitationCode.text];
                    
                    if (sqlite3_prepare_v2(db, [sqlCheckCode UTF8String], -1, &statement, NULL) == SQLITE_OK){
                        if (sqlite3_step(statement) != SQLITE_DONE){
                            NSString *accountType = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                            [database deleteAttributesWithRequirement:[NSString stringWithFormat:@"code = '%@'", self.textInvitationCode.text]
                                                            fromTable:@"InvitationCode"];
                            [database openOrCreateTable:@"Accounts"
                                       withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
                            [database insertAttributes:[NSString stringWithFormat:@"'%@', '%@', '%@'", self.textUserName.text, self.textPassword.text, accountType]
                                       forDescriptions:@"'userName', 'userPassword', 'accountType'"
                                             intoTable:@"Accounts"];
                            
                            if ([accountType isEqualToString:@"master"]){
                                MasterHomepageTableViewController *MHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MasterHomepage"];
                                MHTVC.title = @"管理员主页";
                                MHTVC.loadedUserName = self.textUserName.text;
                                [self.navigationController pushViewController:MHTVC animated:YES];
                                MHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                            } else {
                                VolunteerHomepageTableViewController *VHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VolunteerHomepage"];
                                VHTVC.title = @"志愿者主页";
                                VHTVC.loadedUserName = self.textUserName.text;
                                [self.navigationController pushViewController:VHTVC animated:YES];
                                VHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                            }
                        } else {
                            [database alertBox:@"错误" message:@"邀请码无效" withCancelButton:@"确认"];
                        }
                    }
                    
                }
            } else {
                [database alertBox:@"错误" message:@"密码不匹配，请重新输入" withCancelButton:@"确认"];
            }
        } else {
            [database alertBox:@"错误" message:@"密码不符合要求 (最少8个字符)" withCancelButton:@"确认"];
        }
    } else {
        [database alertBox:@"错误" message:@"用户名不符合要求 (最少6个字符)" withCancelButton:@"确认"];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

@end
