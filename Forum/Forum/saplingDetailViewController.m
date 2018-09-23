//
//  saplingDetailViewController.m
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "saplingDetailViewController.h"
#import "commentViewController.h"

@interface saplingDetailViewController ()

@property (nonatomic,strong) IBOutlet UITextView *textViewSaplingDetail;
@property (nonatomic,strong) IBOutlet UILabel *labelUserName;
@property (nonatomic,strong) IBOutlet UILabel *labelSaplingDate;

@end

@implementation saplingDetailViewController

sqlite3 *db;

- (void)viewDidAppear:(BOOL)animated
{
    self.textViewSaplingDetail.text = self.saplingContent;
    self.labelUserName.text = self.saplingUserName;
    self.labelSaplingDate.text = self.saplingDate;
    [self setupTableView];
    self.datasource.saplingID = self.saplingID;
    [self.datasource fetchComments];
    self.comments = self.datasource.comments;
    [self setComments:self.comments];
}

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    [self.tableView reloadData];
}

- (void)setupTableView
{
    self.datasource = [[commentTableDataSource alloc] init];
    self.delegate = [[commentTableDelegate alloc] init];
    
    self.tableView.dataSource = self.datasource;
    self.tableView.delegate = self.delegate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Comment"])
    {
        commentViewController *CVC = segue.destinationViewController;
        CVC.userName = self.commentUserName;
        CVC.saplingID = self.saplingID;
    }
}

@end
