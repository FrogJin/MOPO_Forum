//
//  mineTableViewController.h
//  Forum
//
//  Created by Tim-Jin on 15-7-26.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface mineTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *records;
@property (nonatomic,strong) NSString *userName;

@end
