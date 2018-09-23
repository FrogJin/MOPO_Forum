//
//  mineTableCell.h
//  Forum
//
//  Created by Tim-Jin on 15-7-26.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mineTableCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *imageViewUserPortrait;
@property (nonatomic,strong) IBOutlet UITextView *textViewContent;
@property (nonatomic,strong) IBOutlet UILabel *labelType;
@property (nonatomic,strong) IBOutlet UILabel *labelDate;

@end
