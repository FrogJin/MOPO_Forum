//
//  saplingDetailViewController.h
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "commentTableDataSource.h"
#import "commentTableDelegate.h"

@interface saplingDetailViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) commentTableDataSource *datasource;
@property (nonatomic,strong) commentTableDelegate *delegate;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) NSString *saplingID;
@property (nonatomic,strong) NSString *saplingUserName;
@property (nonatomic,strong) NSString *loadedUserName;
@property (nonatomic,strong) NSString *saplingContent;
@property (nonatomic,strong) NSString *saplingDate;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_1;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_2;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_3;
@property (strong, nonatomic) NSData *imageData_1;
@property (strong, nonatomic) NSData *imageData_2;
@property (strong, nonatomic) NSData *imageData_3;

@end
