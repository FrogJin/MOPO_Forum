//
//  UserDatabase.h
//  Forum
//
//  Created by Tim-Jin on 15-7-8.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface UserDatabase : NSObject

- (void)openOrCreateDatabase;
- (void)execSql:(NSString *)sql;

@end
