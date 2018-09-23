//
//  SQLiteDatabase.m
//  MOPO Forum V1.0
//
//  Created by 城投物业 on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SQLiteDatabase.h"

@implementation SQLiteDatabase

sqlite3 *db;

- (void)alertBox:(NSString *)caution
         message:(NSString *)solution
withCancelButton:(NSString *)cancelButtonTitle
  andOtherButton:(NSString *)otherButtonTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caution
                                                        message:solution
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
    [alertView show];
}

- (void)execSql:(NSString *)sql
{
    char *errMsg;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
    {
        sqlite3_close(db);
        [self alertBox:@"Database Error" message:@"SQL Executed Failed" withCancelButton:@"OK" andOtherButton:nil];
    }
}

- (void)openOrCreateDatabase:(NSString *)databaseName
{
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",databaseName]];
    if(sqlite3_open([databasePath UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        [self alertBox:@"Database Error" message:@"Database Opened Failed" withCancelButton:@"OK" andOtherButton:nil];
    }
}

- (void)openOrCreateTable:(NSString *)tableName withDescriptions:(NSString *)descriptions
{
    NSString *sqlOpenOrCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", tableName, descriptions];
    [self execSql:sqlOpenOrCreateTable];
}

- (void)dropTable:(NSString *)tableName
{
    NSString *sqlDropTable = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    [self execSql:sqlDropTable];
}

- (void)insertAttributes:(NSString *)attributes forDescriptions:(NSString *)descriptions intoTable:(NSString *)tableName
{
    NSString *sqlInsertAttributes = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (%@)", tableName, descriptions, attributes];
    [self execSql:sqlInsertAttributes];
}

- (void)deleteAttributes:(NSString *)attributes withRequirement:(NSString *)requirement fromTable:(NSString *)tableName
{
    NSString *sqlDeleteAttributes = [NSString stringWithFormat:@"DELETE %@ FROM %@ WHERE %@", attributes, tableName, requirement];
    [self execSql:sqlDeleteAttributes];
}

@end
