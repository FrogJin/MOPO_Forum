//
//  SelfTableCell.h
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-7.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfTableCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *imageViewUserPortrait;
@property (nonatomic,strong) IBOutlet UITextView *textViewContent;
@property (nonatomic,strong) IBOutlet UILabel *labelType;
@property (nonatomic,strong) IBOutlet UILabel *labelDate;

@end
