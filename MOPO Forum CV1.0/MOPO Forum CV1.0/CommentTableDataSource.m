//
//  commentTableDataSource.m
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "commentTableDataSource.h"
#import "commentTableCell.h"
#import "SQLiteDatabase.h"

@implementation commentTableDataSource

sqlite3 *db;

#pragma mark - Table View Data Source

- (void)fetchComments {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database openOrCreateDatabase:@"SaplingInfo"];
    [database openOrCreateTable:@"Comments" withDescriptions:@"commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT"];
    
    NSString *sqlCommentCollection = [NSString stringWithFormat:@"SELECT * FROM Comments WHERE saplingID = '%@'", self.saplingID];
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
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commentTableCell *cell = (commentTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *comment = self.comments[indexPath.row];
    cell.labelUserName.text = [comment valueForKeyPath:@"userName"];
    [cell.textViewComment.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [cell.textViewComment.layer setBorderWidth:2];
    cell.textViewComment.layer.cornerRadius = 5;
    cell.textViewComment.text = [comment valueForKeyPath:@"commentContent"];
    cell.labelCommentDate.text = [comment valueForKeyPath:@"commentDate"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"Accounts" withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
    NSString *sqlSelfInfo = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", cell.labelUserName.text];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlSelfInfo UTF8String], -1, &statement, NULL) == SQLITE_OK){
        sqlite3_step(statement);
        NSData *userPortraitData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
        if (userPortraitData.length != 0) {
            cell.imageViewUserPortrait.image = [[UIImage alloc] initWithData:userPortraitData];
        } else {
            cell.imageViewUserPortrait.image = [UIImage imageNamed:@"Plus"];
        }
        cell.imageViewUserPortrait.layer.borderWidth = 2.0;
        cell.imageViewUserPortrait.layer.cornerRadius = 10;
        cell.imageViewUserPortrait.layer.masksToBounds = YES;
        cell.imageViewUserPortrait.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);

    return cell;
}

@end
