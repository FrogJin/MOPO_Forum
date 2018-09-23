//
//  mineTableViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-26.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "mineTableViewController.h"
#import "mineTableCell.h"
#import "UserDatabase.h"

@interface mineTableViewController ()

@end

@implementation mineTableViewController

sqlite3 *db;

#pragma mark - UITableViewDataSource

- (void)viewDidAppear:(BOOL)animated{
    [self fetchRecords];
    [self setRecords:self.records];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)setRecords:(NSArray *)records
{
    _records = records;
    [self.tableView reloadData];
}

- (void)fetchRecords
{
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    sqlite3_stmt *statement = nil;
    
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS SAPLINGCOLLECTION (saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSMutableArray *recordsArray = [NSMutableArray array];
    
    NSString *sqlSaplingRecordsCollection = [NSString stringWithFormat:@"SELECT * FROM SAPLINGCOLLECTION WHERE userName = '%@'", self.userName];
    if (sqlite3_prepare_v2(db, [sqlSaplingRecordsCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *recordType = @"sapling";
            NSString *saplingID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            NSString *saplingTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *saplingDate = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString *saplingTime = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            
            NSMutableArray *saplingInfo = [[NSMutableArray alloc] init];
            [saplingInfo addObject:recordType];
            [saplingInfo addObject:saplingID];
            [saplingInfo addObject:userName];
            [saplingInfo addObject:saplingTitle];
            [saplingInfo addObject:saplingDate];
            [saplingInfo addObject:saplingTime];
            
            NSMutableArray *saplingKeys = [[NSMutableArray alloc] init];
            [saplingKeys addObject:@"recordType"];
            [saplingKeys addObject:@"saplingID"];
            [saplingKeys addObject:@"userName"];
            [saplingKeys addObject:@"content"];
            [saplingKeys addObject:@"date"];
            [saplingKeys addObject:@"time"];
            
            NSMutableDictionary *saplingDictionary = [[NSMutableDictionary alloc] initWithObjects:saplingInfo forKeys:saplingKeys];
            
            [recordsArray addObject:saplingDictionary];
        }
        sqlite3_finalize(statement);
    }
    
    statement = nil;
    
    sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS COMMENTCOLLECTION (commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSString *sqlCommentRecordsCollection = [NSString stringWithFormat:@"SELECT * FROM COMMENTCOLLECTION WHERE userName = '%@'", self.userName];
    if (sqlite3_prepare_v2(db, [sqlCommentRecordsCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *recordType = @"comment";
            NSString *commentID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *saplingID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,2)];
            NSString *commentContent = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *commentDate = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString *commentTime = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            
            NSMutableArray *commentInfo = [[NSMutableArray alloc] init];
            [commentInfo addObject:recordType];
            [commentInfo addObject:commentID];
            [commentInfo addObject:saplingID];
            [commentInfo addObject:userName];
            [commentInfo addObject:commentContent];
            [commentInfo addObject:commentDate];
            [commentInfo addObject:commentTime];
            
            NSMutableArray *commentKeys = [[NSMutableArray alloc] init];
            [commentKeys addObject:@"recordType"];
            [commentKeys addObject:@"commentID"];
            [commentKeys addObject:@"saplingID"];
            [commentKeys addObject:@"userName"];
            [commentKeys addObject:@"content"];
            [commentKeys addObject:@"date"];
            [commentKeys addObject:@"time"];
            
            NSMutableDictionary *commentDictionary = [[NSMutableDictionary alloc] initWithObjects:commentInfo forKeys:commentKeys];
            
            [recordsArray addObject:commentDictionary];
        }
        sqlite3_finalize(statement);
    }
    
    NSSortDescriptor *sortTime = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    self.records = [recordsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortTime, nil]];
    sqlite3_close(db);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mineTableCell *cell = (mineTableCell *)[tableView dequeueReusableCellWithIdentifier:@"mineTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mineTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *record = self.records[indexPath.row];
    cell.labelType.text = [record valueForKeyPath:@"recordType"];
    cell.labelDate.text = [record valueForKeyPath:@"date"];
    cell.textViewContent.text = [record valueForKeyPath:@"content"];
    if ([cell.labelType.text isEqualToString:@"sapling"])
    {
        cell.imageViewUserPortrait.image = [UIImage imageNamed:@"Plant"];
    } else {
        cell.imageViewUserPortrait.image = [UIImage imageNamed:@"write"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UserDatabase *database = [[UserDatabase alloc] init];
        [database openOrCreateDatabase];
        
        NSDictionary *record = self.records[indexPath.row];
        if ([[record valueForKeyPath:@"recordType"] isEqualToString:@"sapling"])
        {
            NSString *saplingID = [record valueForKeyPath:@"saplingID"];
            
            NSString *sqlDeleteSapling = [NSString stringWithFormat:@"DELETE FROM SAPLINGCOLLECTION WHERE saplingID = '%@'", saplingID];
            [database execSql:sqlDeleteSapling];
            
            NSString *sqlDeleteRelatingComment = [NSString stringWithFormat:@"DELETE FROM COMMENTCOLLECTION WHERE saplingID = '%@'", saplingID];
            [database execSql:sqlDeleteRelatingComment];
        } else {
            NSString *commentID = [record valueForKeyPath:@"commentID"];
            
            NSString *sqlDeleteComment = [NSString stringWithFormat:@"DELETE FROM COMMENTCOLLECTION WHERE commentID = '%@'", commentID];
            [database execSql:sqlDeleteComment];
        }
        sqlite3_close(db);
        [self viewDidAppear:YES];
    }
}

@end
