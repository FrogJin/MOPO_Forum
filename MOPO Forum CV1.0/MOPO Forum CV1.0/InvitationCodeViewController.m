//
//  InvitationCodeViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-2.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "InvitationCodeViewController.h"
#import "SQLiteDatabase.h"

@interface InvitationCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (strong, nonatomic)NSArray *pickerCodeType;
@property (strong, nonatomic)NSString *codeType;

@end

@implementation InvitationCodeViewController

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    _pickerCodeType = @[@"master", @"volunteer"];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return _pickerCodeType.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return _pickerCodeType[row];
}

#pragma mark - Picker View Delegate

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.codeType = _pickerCodeType[row];
}

#pragma mark - IBAction

- (IBAction)buttonGenerateInvitationCode:(id)sender {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database openOrCreateDatabase:@"UserInfo"];
    [database openOrCreateTable:@"InvitationCode"
               withDescriptions:@"codeID INTEGER PRIMARY KEY, code TEXT, codeType TEXT"];
    
    NSString *code = [NSString stringWithFormat:@"%0.10u", arc4random()];
    NSString *sqlCheckCode = [NSString stringWithFormat:@"SELECT * FROM InvitationCode WHERE code = '%@'", code];
    
    if (sqlite3_prepare_v2(db, [sqlCheckCode UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_DONE) {
            code = [NSString stringWithFormat:@"%0.10u", arc4random()];
        }
        [database insertAttributes:[NSString stringWithFormat:@"'%@', '%@'", code, self.codeType]
                   forDescriptions:@"'code', 'codeType'"
                         intoTable:@"InvitationCode"];
        self.textCode.text = code;
        [database alertBox:@"提示" message:@"成功生成邀请码" withCancelButton:@"确认"];
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

@end
