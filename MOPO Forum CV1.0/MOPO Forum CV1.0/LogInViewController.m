//
//  LogInViewController.m
//  MOPO Forum V1.0
//
//  Created by Tim Jin on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "LogInViewController.h"
#import "MasterHomepageTableViewController.h"
#import "VolunteerHomepageTableViewController.h"
#import "PublicHomepageTableViewController.h"
#import "SQLiteDatabase.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelHideOrShowPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) IBOutlet UISwitch *switchHideOrShow;

@end

@implementation LogInViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    [self.switchHideOrShow setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4]];
    self.switchHideOrShow.layer.cornerRadius = 15;
    [self.buttonConfirm setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4]];
}

- (IBAction)backgroundTap:(id)sender {
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (IBAction)passwordHideOrShow:(id)sender {
    if (self.textPassword.secureTextEntry == true)
    {
        self.textPassword.secureTextEntry = false;
        self.labelHideOrShowPassword.text = @"侧滑隐藏密码";
    } else {
        self.textPassword.secureTextEntry = true;
        self.labelHideOrShowPassword.text = @"侧滑显示密码";
    }
}

#pragma mark - IBAction

- (IBAction)buttonConfirm:(id)sender {
    
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database openOrCreateDatabase:@"UserInfo"];
    sqlite3_stmt *statement = nil;
    [database openOrCreateTable:@"Accounts"
               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
    NSString *sqlCheckAccount = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", self.textUserName.text];
    
    if (sqlite3_prepare_v2(db, [sqlCheckAccount UTF8String], -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) != SQLITE_DONE){
            NSString *userPassword = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            if ([self.textPassword.text isEqualToString:userPassword]){
                NSString *accountType = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                if ([accountType isEqualToString:@"master"]){
                    MasterHomepageTableViewController *MHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MasterHomepage"];
                    MHTVC.title = @"管理员主页";
                    MHTVC.loadedUserName = userName;
                    [self.navigationController pushViewController:MHTVC animated:YES];
                    MHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                } else if ([accountType isEqualToString:@"volunteer"]){
                    VolunteerHomepageTableViewController *VHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VolunteerHomepage"];
                    VHTVC.title = @"志愿者主页";
                    VHTVC.loadedUserName = userName;
                    [self.navigationController pushViewController:VHTVC animated:YES];
                    VHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                } else {
                    PublicHomepageTableViewController *PHTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PublicHomepage"];
                    PHTVC.title = @"公共主页";
                    PHTVC.loadedUserName = userName;
                    [self.navigationController pushViewController:PHTVC animated:YES];
                    PHTVC.navigationController.topViewController.navigationItem.hidesBackButton = YES;
                }
                
            } else {
                [database alertBox:@"错误" message:@"用户名或密码错误" withCancelButton:@"确认"];
            }
        } else {
            [database alertBox:@"错误" message:@"用户名或密码错误" withCancelButton:@"确认"];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

@end
