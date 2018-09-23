//
//  SelfViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-6.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SelfViewController.h"
#import "SelfTableCell.h"
#import "SQLiteDatabase.h"
#import "DescriptionViewController.h"

@interface SelfViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@end

@implementation SelfViewController

@synthesize imagePickerController;
sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database invokeLoadingIndicator];
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"Accounts"
               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
    NSString *sqlSelfInfo = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", self.loadedUserName];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlSelfInfo UTF8String], -1, &statement, NULL) == SQLITE_OK){
        sqlite3_step(statement);
        NSData *userPortraitData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
        if (userPortraitData.length != 0) {
            self.imageViewUserPortrait.image = [[UIImage alloc] initWithData:userPortraitData];
        } else {
            self.imageViewUserPortrait.image = [UIImage imageNamed:@"Plus"];
        }
        
        if (sqlite3_column_text(statement, 5) != NULL){
            NSString *userDescription = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            self.textViewDescription.text = userDescription;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    if (imagePickerController == nil){
        UIImagePickerController *aImagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController = aImagePickerController;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.labelUserName.text = self.loadedUserName;
    [self fetchRecords];
    [self setRecords:self.records];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [database dismissLoadingIndicator];
}

- (void)setRecords:(NSArray *)records {
    _records = records;
    [self.tableView reloadData];
}

- (void)fetchRecords {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    [database openOrCreateDatabase:@"SaplingInfo"];
    sqlite3_stmt *statement;
    [database openOrCreateTable:@"Saplings"
               withDescriptions:@"saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT, saplingImage_1 BLOB, 'saplingImage_2' BLOB, 'saplingImage_3' BLOB"];
    
    NSMutableArray *recordsArray = [NSMutableArray array];
    
    NSString *sqlSaplingRecordsCollection = [NSString stringWithFormat:@"SELECT * FROM Saplings WHERE userName = '%@'", self.loadedUserName];
    if (sqlite3_prepare_v2(db, [sqlSaplingRecordsCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *recordType = @"sapling";
            NSString *saplingID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            NSString *saplingTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *saplingDate = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *saplingTime = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            
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
        statement = nil;
    }
    
    [database openOrCreateTable:@"Comments"
               withDescriptions:@"commentID INTEGER PRIMARY KEY, saplingID INTEGER, userName TEXT, commentContent TEXT, commentDate TEXT, commentTime TEXT"];
    
    NSString *sqlCommentRecordsCollection = [NSString stringWithFormat:@"SELECT * FROM Comments WHERE userName = '%@'", self.loadedUserName];
    if (sqlite3_prepare_v2(db, [sqlCommentRecordsCollection UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *recordType = @"comment";
            NSString *commentID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *saplingID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *userName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,2)];
            NSString *commentContent = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *commentDate = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *commentTime = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            
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
    }
    
    NSSortDescriptor *sortTime = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    self.records = [recordsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortTime, nil]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.records count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelfTableCell *cell = (SelfTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SelfTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelfTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *record = self.records[indexPath.row];
    cell.labelType.text = [record valueForKeyPath:@"recordType"];
    if ([cell.labelType.text isEqualToString:@"sapling"]){
        cell.imageViewUserPortrait.image = [UIImage imageNamed:@"Sapling"];
    } else {
        cell.imageViewUserPortrait.image = [UIImage imageNamed:@"Comment"];
    }
    cell.labelDate.text = [record valueForKeyPath:@"date"];
    cell.textViewContent.text = [record valueForKeyPath:@"content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
        [database openOrCreateDatabase:@"SaplingInfo"];
        
        NSDictionary *record = self.records[indexPath.row];
        if ([[record valueForKeyPath:@"recordType"] isEqualToString:@"sapling"])
        {
            NSString *saplingID = [record valueForKeyPath:@"saplingID"];
            [database deleteAttributesWithRequirement:[NSString stringWithFormat:@"saplingID = '%@'", saplingID]
                                            fromTable:@"Saplings"];
            [database deleteAttributesWithRequirement:[NSString stringWithFormat:@"saplingID = '%@'", saplingID]
                                            fromTable:@"Comments"];
        } else {
            NSString *commentID = [record valueForKeyPath:@"commentID"];
            [database deleteAttributesWithRequirement:[NSString stringWithFormat:@"commentID = '%@'", commentID]
                                            fromTable:@"Comments"];
        }
        
        sqlite3_close(db);
        [self viewDidAppear:YES];
    }
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageViewUserPortrait.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"Accounts" withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];

    NSString *sqlUpdateImage = [NSString stringWithFormat:@"UPDATE Accounts SET userPortrait = ? WHERE userName = '%@'", self.loadedUserName];
    if (sqlite3_prepare_v2(db, [sqlUpdateImage UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_blob(statement, 1, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
        sqlite3_step(statement);
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)buttonUpload:(id)sender {
    [self.navigationController presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)buttonWriteDescription:(id)sender {
    DescriptionViewController *DVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Description"];
    DVC.title = @"自我介绍";
    DVC.loadedUserName = self.loadedUserName;
    [self.navigationController pushViewController:DVC animated:YES];
}

@end
