//
//  commentTableDataSource.m
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "commentTableDataSource.h"
#import "commentTableCell.h"
#import "UserDatabase.h"

@implementation commentTableDataSource

sqlite3 *db;

- (void)fetchComments
{
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    sqlite3_stmt *statement = nil;
    
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS COMMENTCOLLECTION (commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSString *sqlCommentCollection = [NSString stringWithFormat:@"SELECT * FROM COMMENTCOLLECTION WHERE saplingID = '%@'", self.saplingID];
    if (sqlite3_prepare_v2(db, [sqlCommentCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        NSMutableArray *commentArray = [NSMutableArray array];
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,2)];
            NSString *commentContent = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *commentDate = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString *commentTime = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            
            NSMutableArray *commentInfo = [[NSMutableArray alloc] init];
            [commentInfo addObject:self.saplingID];
            [commentInfo addObject:userName];
            [commentInfo addObject:commentContent];
            [commentInfo addObject:commentDate];
            [commentInfo addObject:commentTime];
            
            NSMutableArray *commentKeys = [[NSMutableArray alloc] init];
            [commentKeys addObject:@"saplingID"];
            [commentKeys addObject:@"userName"];
            [commentKeys addObject:@"commentContent"];
            [commentKeys addObject:@"commentDate"];
            [commentKeys addObject:@"commentTime"];
            
            NSMutableDictionary *commentDictionary = [[NSMutableDictionary alloc] initWithObjects:commentInfo forKeys:commentKeys];
            
            [commentArray addObject:commentDictionary];
        }
        NSSortDescriptor *sortTime = [[NSSortDescriptor alloc] initWithKey:@"commentTime" ascending:YES];
        self.comments = [commentArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortTime, nil]];
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentTableCell *cell = (commentTableCell *)[tableView dequeueReusableCellWithIdentifier:@"commentTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"commentTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *comment = self.comments[indexPath.row];
    cell.labelUserName.text = [comment valueForKeyPath:@"userName"];
    cell.textViewComment.text = [comment valueForKeyPath:@"commentContent"];
    cell.labelCommentDate.text = [comment valueForKeyPath:@"commentDate"];
    cell.imageViewUserPortrait.image = [UIImage imageNamed:@"write"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
