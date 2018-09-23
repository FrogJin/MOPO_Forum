//
//  SQLiteDatabase.h
//  MOPO Forum V1.0
//
//  Created by Tim Jin on 15-7-30.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteDatabase : NSObject

- (void)alertBox:(NSString *)caution
         message:(NSString *)solution
withCancelButton:(NSString *)cancelButtonTitle;
- (void)alertBox:(NSString *)caution
         message:(NSString *)solution
withCancelButton:(NSString *)cancelButtonTitle
  andOtherButton:(NSString *)otherButtonTitle;
- (void)invokeLoadingIndicator;
- (void)dismissLoadingIndicator;
- (void)execSql:(NSString *)sql;

- (void)openOrCreateDatabase:(NSString *)databaseName;
- (void)openOrCreateTable:(NSString *)tableName
         withDescriptions:(NSString *)descriptions;
- (void)dropTable:(NSString *)tableName;
- (void)insertAttributes:(NSString *)attributes
         forDescriptions:(NSString *)descriptions
               intoTable:(NSString *)tableName;
- (void)deleteAttributesWithRequirement:(NSString *)requirement
                              fromTable:(NSString *)tableName;

@property(strong, nonatomic)UIAlertView *alertView;

@end
