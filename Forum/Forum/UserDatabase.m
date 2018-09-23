//
//  UserDatabase.m
//  Forum
//
//  Created by Tim-Jin on 15-7-8.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "UserDatabase.h"

@implementation UserDatabase

sqlite3 *db;

#define databaseName    @"UserInfo.sqlite"

- (void)openOrCreateDatabase
{
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:databaseName];
    NSLog(@"%@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        NSLog(@"database Opened Successfully");
    } else {
        sqlite3_close(db);
        NSLog(@"database Opened Failed");
    }
}

- (void)execSql:(NSString *)sql
{
    char *errMsg;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK)
    {
        NSLog(@"'%@' Executed Successfully", sql);
    } else {
        sqlite3_close(db);
        NSLog(@"'%@' Executed Failed", sql);
    }
}

@end
