//
//  commentViewController.h
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface commentViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,strong) IBOutlet UITextView *textViewEditComment;
@property (nonatomic,strong) NSString *saplingID;
@property (nonatomic,strong) NSString *userName;

@end
