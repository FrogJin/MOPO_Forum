//
//  saplingTableCell.h
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface saplingTableCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *imageViewUserPortrait;
@property (nonatomic,weak) IBOutlet UILabel *labelUserName;
@property (nonatomic,weak) IBOutlet UILabel *labelSaplingTitle;
@property (nonatomic,weak) IBOutlet UILabel *labelSaplingContent;
@property (nonatomic,weak) IBOutlet UILabel *labelSaplingDate;

@end
