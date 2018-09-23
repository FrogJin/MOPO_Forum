//
//  SaplingViewController.h
//  Forum
//
//  Created by Tim-Jin on 15-7-20.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SaplingViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,strong) IBOutlet UITextView *textViewEditSapling;

@property (nonatomic,strong) NSString *userName;

@end
