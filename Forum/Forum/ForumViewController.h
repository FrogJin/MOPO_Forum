//
//  ForumViewController.h
//  Forum
//
//  Created by Tim-Jin on 15-7-1.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ForumViewController : UIViewController

@property (strong,nonatomic) NSString *loadUserID;
@property (strong,nonatomic) NSString *loadUserName;

- (IBAction)buttonConfirm:(id)sender;
- (IBAction)passwordHideOrShow:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
