//
//  saplingTableCell.h
//  Forum
//
//  Created by Tim Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface saplingTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelSaplingTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSaplingContent;
@property (weak, nonatomic) IBOutlet UILabel *labelSaplingDate;

@end
