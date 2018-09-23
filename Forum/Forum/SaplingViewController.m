//
//  SaplingViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-20.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SaplingViewController.h"
#import "HomepageTableViewController.h"
#import "UserDatabase.h"

@interface SaplingViewController ()

@property (nonatomic,strong) IBOutlet UITextField *textTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelCount;

@end

@implementation SaplingViewController

sqlite3 *db;

- (void)viewDidLoad
{
    [self.textViewEditSapling.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewEditSapling.layer setBorderWidth:2];
    self.textViewEditSapling.layer.cornerRadius = 5;
    self.textViewEditSapling.delegate = self;
}

- (void)alertBox:(NSString *)caution message:(NSString *)solution;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caution message:solution delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)textTitleEnter:(id)sender {
    [self.textTitle resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.textViewEditSapling resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger newTextLength = [textView.text length] - range.length + [text length];
    if (newTextLength > 250)
    {
        return NO;
    } else {
        self.labelCount.text = [NSString stringWithFormat:@"%i / 250", newTextLength];
        return YES;
    }
}

- (IBAction)buttonUpdate:(id)sender {
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS SAPLINGCOLLECTION (saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSString *saplingTitle = self.textTitle.text;
    NSString *saplingContent = self.textViewEditSapling.text;
    NSDate *Date = [NSDate date];
    NSString *saplingTime = [[NSString alloc] initWithFormat:@"%@", Date];
    NSArray *arrayDate = [saplingTime componentsSeparatedByString:@" "];
    NSString *saplingDate = [arrayDate objectAtIndex:0];
    
    if (![saplingTitle isEqualToString:@""])
    {
        if(![saplingContent isEqualToString:@""])
        {
            NSString *sqlPlantSapling = [NSString stringWithFormat: @"INSERT INTO SAPLINGCOLLECTION ('userName', 'saplingTitle', 'saplingContent', 'saplingDate', 'saplingTime') VALUES ('%@', '%@', '%@', '%@', '%@')", self.userName, saplingTitle, saplingContent, saplingDate, saplingTime];
            [database execSql:sqlPlantSapling];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self alertBox:@"Error" message:@"Please input Content !"];
        }
    } else {
        [self alertBox:@"Error" message:@"Please input Title !"];
    }
    sqlite3_close(db);
}

@end
