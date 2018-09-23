//
//  DescriptionViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-9.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "DescriptionViewController.h"
#import "SQLiteDatabase.h"

@interface DescriptionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewEditDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@end

@implementation DescriptionViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textViewEditDescription.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewEditDescription.layer setBorderWidth:2];
    self.textViewEditDescription.layer.cornerRadius = 5;
    self.textViewEditDescription.delegate = self;
}

- (IBAction)backgroundTap:(id)sender {
    [self.textViewEditDescription resignFirstResponder];
}

#pragma mark - Text View Delegate

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    NSInteger newTextLength = [textView.text length] - range.length + [text length];
    if (newTextLength > 50)
    {
        return NO;
    } else {
        self.labelCount.text = [NSString stringWithFormat:@"%i / 50", newTextLength];
        return YES;
    }
}

#pragma mark - IBAction

- (IBAction)buttonWriteComment:(id)sender {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"Accounts"
               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
    
    NSString *description = self.textViewEditDescription.text;
    if(![description isEqualToString:@""])
    {
        NSString *sqlUpdateDescription = [NSString stringWithFormat:@"UPDATE Accounts SET userDescription = ? WHERE userName = '%@'", self.loadedUserName];
        if (sqlite3_prepare_v2(db, [sqlUpdateDescription UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(statement, 1, [description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [database alertBox:@"错误" message:@"请输入自我介绍" withCancelButton:@"确认"];
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

@end
