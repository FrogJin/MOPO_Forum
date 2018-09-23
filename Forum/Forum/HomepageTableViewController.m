//
//  HomepageTableViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-18.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "HomepageTableViewController.h"
#import "SaplingViewController.h"
#import "saplingDetailViewController.h"
#import "commentTableDataSource.h"
#import "saplingTableCell.h"
#import "mineTableViewController.h"
#import "UserDatabase.h"

@interface HomepageTableViewController ()

@end

@implementation HomepageTableViewController

sqlite3 *db;

#pragma mark - UITableViewDataSource

- (void)viewDidAppear:(BOOL)animated{
    [self fetchSaplings];
    [self setSaplings:self.saplings];
}

- (void)setSaplings:(NSArray *)saplings
{
    _saplings = saplings;
    [self.tableView reloadData];
}

- (void)fetchSaplings
{
    UserDatabase *database = [[UserDatabase alloc] init];
    [database openOrCreateDatabase];
    sqlite3_stmt *statement = nil;
    
    NSString *sqlOpenOrCreateTable = @"CREATE TABLE IF NOT EXISTS SAPLINGCOLLECTION (saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT)";
    [database execSql:sqlOpenOrCreateTable];
    
    NSString *sqlSaplingCollection = [NSString stringWithFormat:@"SELECT * FROM SAPLINGCOLLECTION"];
    if (sqlite3_prepare_v2(db, [sqlSaplingCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        NSMutableArray *saplingArray = [NSMutableArray array];
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *saplingID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            NSString *saplingTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *saplingContent = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *saplingDate = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString *saplingTime = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            
            NSMutableArray *saplingInfo = [[NSMutableArray alloc] init];
            [saplingInfo addObject:saplingID];
            [saplingInfo addObject:userName];
            [saplingInfo addObject:saplingTitle];
            [saplingInfo addObject:saplingContent];
            [saplingInfo addObject:saplingDate];
            [saplingInfo addObject:saplingTime];
            
            NSMutableArray *saplingKeys = [[NSMutableArray alloc] init];
            [saplingKeys addObject:@"saplingID"];
            [saplingKeys addObject:@"userName"];
            [saplingKeys addObject:@"saplingTitle"];
            [saplingKeys addObject:@"saplingContent"];
            [saplingKeys addObject:@"saplingDate"];
            [saplingKeys addObject:@"saplingTime"];
            
            NSMutableDictionary *saplingDictionary = [[NSMutableDictionary alloc] initWithObjects:saplingInfo forKeys:saplingKeys];
            
            [saplingArray addObject:saplingDictionary];
        }
        NSSortDescriptor *sortTime = [[NSSortDescriptor alloc] initWithKey:@"saplingTime" ascending:NO];
        self.saplings = [saplingArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortTime, nil]];
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
    return [self.saplings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    saplingTableCell *cell = (saplingTableCell *)[tableView dequeueReusableCellWithIdentifier:@"saplingTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"saplingTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *sapling = self.saplings[indexPath.row];
    cell.labelUserName.text = [sapling valueForKeyPath:@"userName"];
    cell.labelSaplingTitle.text = [sapling valueForKeyPath:@"saplingTitle"];
    cell.labelSaplingContent.text = [sapling valueForKeyPath:@"saplingContent"];
    cell.labelSaplingDate.text = [sapling valueForKeyPath:@"saplingDate"];
    cell.imageViewUserPortrait.image = [UIImage imageNamed:@"Plant"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    saplingDetailViewController *SDVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Watch"];
    NSDictionary *sapling =self.saplings[indexPath.row];
    SDVC.saplingID = [sapling valueForKeyPath:@"saplingID"];
    SDVC.saplingUserName = [sapling valueForKeyPath:@"userName"];
    SDVC.commentUserName = self.userName;
    SDVC.title = [sapling valueForKeyPath:@"saplingTitle"];
    SDVC.saplingContent = [sapling valueForKeyPath:@"saplingContent"];
    SDVC.saplingDate = [sapling valueForKeyPath:@"saplingDate"];
    [self.navigationController pushViewController:SDVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"Plant"])
    {
        SaplingViewController *SVC = segue.destinationViewController;
        SVC.userName = self.userName;
    }
    if ([segue.identifier isEqualToString:@"Mine"])
    {
        mineTableViewController *MTVC = segue.destinationViewController;
        MTVC.userName = self.userName;
    }
}

@end
