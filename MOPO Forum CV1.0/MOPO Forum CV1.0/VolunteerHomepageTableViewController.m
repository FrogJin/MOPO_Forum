//
//  VolunteerHomepageTableViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-7-31.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "VolunteerHomepageTableViewController.h"
#import "SQLiteDatabase.h"
#import "saplingTableCell.h"
#import "SaplingViewController.h"
#import "SaplingDetailViewController.h"
#import "SelfViewController.h"

@interface VolunteerHomepageTableViewController ()

@end

@implementation VolunteerHomepageTableViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self fetchSaplings];
    [self setSaplings:self.saplings];
}

- (void)setSaplings:(NSArray *)saplings {
    _saplings = saplings;
    [self.tableView reloadData];
}

- (void)fetchSaplings {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database invokeLoadingIndicator];
    [database openOrCreateDatabase:@"SaplingInfo"];
    [database openOrCreateTable:@"Saplings"
               withDescriptions:@"saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT, saplingImage_1 BLOB, 'saplingImage_2' BLOB, 'saplingImage_3' BLOB"];
    
    NSString *sqlSaplingCollection = [NSString stringWithFormat:@"SELECT * FROM Saplings"];
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
            NSData *saplingImage_1 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 6) length:sqlite3_column_bytes(statement, 6)];
            NSData *saplingImage_2 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 7) length:sqlite3_column_bytes(statement, 7)];
            NSData *saplingImage_3 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 8) length:sqlite3_column_bytes(statement, 8)];
            
            NSMutableArray *saplingInfo = [[NSMutableArray alloc] init];
            [saplingInfo addObject:saplingID];
            [saplingInfo addObject:userName];
            [saplingInfo addObject:saplingTitle];
            [saplingInfo addObject:saplingContent];
            [saplingInfo addObject:saplingDate];
            [saplingInfo addObject:saplingTime];
            [saplingInfo addObject:saplingImage_1];
            [saplingInfo addObject:saplingImage_2];
            [saplingInfo addObject:saplingImage_3];
            
            NSMutableArray *saplingKeys = [[NSMutableArray alloc] init];
            [saplingKeys addObject:@"saplingID"];
            [saplingKeys addObject:@"userName"];
            [saplingKeys addObject:@"saplingTitle"];
            [saplingKeys addObject:@"saplingContent"];
            [saplingKeys addObject:@"saplingDate"];
            [saplingKeys addObject:@"saplingTime"];
            [saplingKeys addObject:@"saplingImage_1"];
            [saplingKeys addObject:@"saplingImage_2"];
            [saplingKeys addObject:@"saplingImage_3"];
            
            NSMutableDictionary *saplingDictionary = [[NSMutableDictionary alloc] initWithObjects:saplingInfo forKeys:saplingKeys];
            [saplingArray addObject:saplingDictionary];
        }
        NSSortDescriptor *sortTime = [[NSSortDescriptor alloc] initWithKey:@"saplingTime" ascending:NO];
        self.saplings = [saplingArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortTime, nil]];
    }
    
    [database dismissLoadingIndicator];
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.saplings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    saplingTableCell *cell = (saplingTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SaplingTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaplingTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *sapling = self.saplings[indexPath.row];
    cell.labelUserName.text = [sapling valueForKeyPath:@"userName"];
    cell.labelSaplingTitle.text = [sapling valueForKeyPath:@"saplingTitle"];
    cell.labelSaplingContent.text = [sapling valueForKeyPath:@"saplingContent"];
    cell.labelSaplingDate.text = [sapling valueForKeyPath:@"saplingDate"];
    
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    saplingDetailViewController *SDVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SaplingDetail"];
    NSDictionary *sapling =self.saplings[indexPath.row];
    SDVC.saplingID = [sapling valueForKeyPath:@"saplingID"];
    SDVC.saplingUserName = [sapling valueForKeyPath:@"userName"];
    SDVC.loadedUserName = self.loadedUserName;
    SDVC.title = [sapling valueForKeyPath:@"saplingTitle"];
    SDVC.saplingContent = [sapling valueForKeyPath:@"saplingContent"];
    SDVC.saplingDate = [sapling valueForKeyPath:@"saplingDate"];
    SDVC.imageData_1 = [sapling valueForKeyPath:@"saplingImage_1"];
    SDVC.imageData_2 = [sapling valueForKeyPath:@"saplingImage_2"];
    SDVC.imageData_3 = [sapling valueForKeyPath:@"saplingImage_3"];
    [self.navigationController pushViewController:SDVC animated:YES];

}

#pragma mark - IBAction

- (IBAction)buttonAdd:(id)sender {
    SaplingViewController *SVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Sapling"];
    SVC.title = @"种树苗";
    SVC.loadedUserName = self.loadedUserName;
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)buttonSelf:(id)sender {
    SelfViewController *SVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Self"];
    SVC.title = @"我自己";
    SVC.loadedUserName = self.loadedUserName;
    [self.navigationController pushViewController:SVC animated:YES];
}

@end
