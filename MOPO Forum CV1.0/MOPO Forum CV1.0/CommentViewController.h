//
//  commentViewController.h
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *saplingID;
@property (strong, nonatomic) NSString *userName;

@end
