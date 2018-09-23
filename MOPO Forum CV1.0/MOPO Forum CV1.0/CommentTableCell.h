//
//  commentTableCell.h
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentTableCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *imageViewUserPortrait;
@property (nonatomic,strong) IBOutlet UITextView *textViewComment;
@property (nonatomic,strong) IBOutlet UILabel *labelUserName;
@property (nonatomic,strong) IBOutlet UILabel *labelCommentDate;

@end
