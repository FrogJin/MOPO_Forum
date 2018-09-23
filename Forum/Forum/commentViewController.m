//
//  commentViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "commentViewController.h"
#import "UserDatabase.h"

@interface commentViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelCount;

@end

@implementation commentViewController

sqlite3 *db;

- (void)viewDidLoad
{
    [self.textViewEditComment.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewEditComment.layer setBorderWidth:2];
    self.textViewEditComment.layer.cornerRadius = 5;
    self.textViewEditComment.delegate = self;
}

- (IBAction)backgroundTap:(id)sender {
    [self.textViewEditComment resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger newTextLength = [textView.text length] - range.length + [text length];
    if (newTextLength > 100)
    {
        return NO;
    } else {
        self.labelCount.text = [NSString stringWithFormat:@"%i / 100", newTextLength];
        return YES;
    }
}

- (IBAction)buttonWriteComment:(id)sender {
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS COMMENTCOLLECTION (commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSString *commentContent = self.textViewEditComment.text;
    NSDate *Date = [NSDate date];
    NSString *commentTime = [[NSString alloc] initWithFormat:@"%@", Date];
    NSArray *arrayDate = [commentTime componentsSeparatedByString:@" "];
    NSString *commentDate = [arrayDate objectAtIndex:0];
    
    if(![commentContent isEqualToString:@""])
    {
        NSString *sqlPlantSapling = [NSString stringWithFormat: @"INSERT INTO COMMENTCOLLECTION ('saplingID', 'userName', 'commentContent', 'commentDate', 'commentTime') VALUES ('%@', '%@', '%@', '%@', '%@')", self.saplingID, self.userName, commentContent, commentDate, commentTime];
        [database execSql:sqlPlantSapling];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Please input comment");
    }
    sqlite3_close(db);
}

@end
