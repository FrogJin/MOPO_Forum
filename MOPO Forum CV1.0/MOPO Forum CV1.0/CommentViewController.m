//
//  commentViewController.m
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "CommentViewController.h"
#import "SQLiteDatabase.h"

@interface commentViewController ()

@property (nonatomic,strong) IBOutlet UITextView *textViewEditComment;
@property (strong, nonatomic) IBOutlet UILabel *labelCount;

@end

@implementation commentViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textViewEditComment.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewEditComment.layer setBorderWidth:2];
    self.textViewEditComment.layer.cornerRadius = 5;
    self.textViewEditComment.delegate = self;
}

- (IBAction)backgroundTap:(id)sender {
    [self.textViewEditComment resignFirstResponder];
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
    [database openOrCreateDatabase:@"SaplingInfo"];
    [database openOrCreateTable:@"Comments"
               withDescriptions:@"commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT"];
    
    NSString *commentContent = self.textViewEditComment.text;
    NSDate *Date = [NSDate date];
    NSString *commentTime = [[NSString alloc] initWithFormat:@"%@", Date];
    NSArray *arrayDate = [commentTime componentsSeparatedByString:@" "];
    NSString *commentDate = [arrayDate objectAtIndex:0];
    
    if(![commentContent isEqualToString:@""])
    {
        [database insertAttributes:[NSString stringWithFormat:@"'%@', '%@', '%@', '%@', '%@'", self.saplingID, self.userName, commentContent, commentDate, commentTime]
                   forDescriptions:@"'saplingID', 'userName', 'commentContent', 'commentDate', 'commentTime'"
                         intoTable:@"Comments"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [database alertBox:@"错误" message:@"请输入评论" withCancelButton:@"确认"];
    }
    
    sqlite3_close(db);
}

@end
