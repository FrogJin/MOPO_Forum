//
//  HomepageTableViewController.h
//  Forum
//
//  Created by Tim-Jin on 15-7-18.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface HomepageTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *saplings;
@property (nonatomic,strong) NSString *userName;

@end
