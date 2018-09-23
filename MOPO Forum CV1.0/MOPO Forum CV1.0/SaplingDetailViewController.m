//
//  saplingDetailViewController.m
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "saplingDetailViewController.h"
#import "ImageViewController.h"
#import "CommentViewController.h"
#import "SQLiteDatabase.h"

@interface saplingDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserPortrait;
@property (strong, nonatomic) IBOutlet UITextView *textViewSaplingDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelSaplingDate;
@property (strong, nonatomic) UIImage *image_1;
@property (strong, nonatomic) UIImage *image_2;
@property (strong, nonatomic) UIImage *image_3;

@end

@implementation saplingDetailViewController

@synthesize buttonImage_1;
@synthesize buttonImage_2;
@synthesize buttonImage_3;
sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database invokeLoadingIndicator];
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"Accounts"
               withDescriptions:@"userID INTEGER PRIMARY KEY, userName TEXT, userPassword TEXT, accountType TEXT, userPortrait BLOB, userDescription TEXT"];
    
    NSData *imageData_1 = [NSData dataWithBytes:self.imageData_1.bytes length:self.imageData_1.length];
    if (imageData_1.length != 0){
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.image_1 = [UIImage imageWithData:imageData_1];
        imageButton.frame = CGRectMake(116, 187, 50, 50);
        buttonImage_1 = imageButton;
        [buttonImage_1 setImage:self.image_1 forState:UIControlStateNormal];
        [buttonImage_1 addTarget:self
                          action:@selector(buttonTouchShow_1:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonImage_1];
    }
    
    NSData *imageData_2 = [NSData dataWithBytes:self.imageData_2.bytes length:self.imageData_2.length];
    if (imageData_2.length != 0){
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.image_2 = [UIImage imageWithData:imageData_2];
        imageButton.frame = CGRectMake(183, 187, 50, 50);
        buttonImage_2 = imageButton;
        [buttonImage_2 setImage:self.image_2 forState:UIControlStateNormal];
        [buttonImage_2 addTarget:self
                          action:@selector(buttonTouchShow_2:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonImage_2];
    }
    
    NSData *imageData_3 = [NSData dataWithBytes:self.imageData_3.bytes length:self.imageData_3.length];
    if (imageData_3.length != 0){
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.image_3 = [UIImage imageWithData:imageData_3];
        imageButton.frame = CGRectMake(250, 187, 50, 50);
        buttonImage_3 = imageButton;
        [buttonImage_3 setImage:self.image_3 forState:UIControlStateNormal];
        [buttonImage_3 addTarget:self
                          action:@selector(buttonTouchShow_3:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonImage_3];
    }
    
    [self.textViewSaplingDetail.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewSaplingDetail.layer setBorderWidth:2];
    self.textViewSaplingDetail.layer.cornerRadius = 5;
    self.textViewSaplingDetail.text = self.saplingContent;
    self.labelUserName.text = self.saplingUserName;
    self.labelSaplingDate.text = self.saplingDate;
    NSString *sqlSelfInfo = [NSString stringWithFormat:@"SELECT * FROM Accounts WHERE userName = '%@'", self.labelUserName.text];
    if (sqlite3_prepare_v2(db, [sqlSelfInfo UTF8String], -1, &statement, NULL) == SQLITE_OK){
        sqlite3_step(statement);
        NSData *userPortraitData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4)
                                                          length:sqlite3_column_bytes(statement, 4)];
        if (userPortraitData.length != 0) {
            self.imageViewUserPortrait.image = [[UIImage alloc] initWithData:userPortraitData];
        } else {
            self.imageViewUserPortrait.image = [UIImage imageNamed:@"Plus"];
        }
        self.imageViewUserPortrait.layer.borderWidth = 2.0;
        self.imageViewUserPortrait.layer.cornerRadius = 10;
        self.imageViewUserPortrait.layer.masksToBounds = YES;
        self.imageViewUserPortrait.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    [self setupTableView];
    self.datasource.saplingID = self.saplingID;
    [self.datasource fetchComments];
    self.comments = self.datasource.comments;
    [self setComments:self.comments];
    
    [database dismissLoadingIndicator];
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;
    [self.tableView reloadData];
}

- (void)setupTableView {
    self.datasource = [[commentTableDataSource alloc] init];
    self.delegate = [[commentTableDelegate alloc] init];
    
    self.tableView.dataSource = self.datasource;
    self.tableView.delegate = self.delegate;
}

- (void)buttonTouchShow_1:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_1;
    [self.navigationController pushViewController:IVC animated:YES];
}

- (void)buttonTouchShow_2:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_2;
    [self.navigationController pushViewController:IVC animated:YES];
}

- (void)buttonTouchShow_3:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_3;
    [self.navigationController pushViewController:IVC animated:YES];
}

#pragma mark - IBAction

- (IBAction)buttonComment:(id)sender {
    commentViewController *CVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Comment"];
    CVC.title = @"写评论";
    CVC.userName = self.loadedUserName;
    CVC.saplingID = self.saplingID;
    [self.navigationController pushViewController:CVC animated:YES];
}

@end
