//
//  commentTableDataSource.h
//  Forum
//
//  Created by Tim-Jin on 15-7-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface commentTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) NSString *saplingID;

- (void)fetchComments;

@end
