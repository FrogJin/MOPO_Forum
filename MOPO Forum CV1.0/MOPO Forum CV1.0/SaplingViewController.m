//
//  SaplingViewController.m
//  Forum
//
//  Created by Tim Jin on 15-7-20.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "SaplingViewController.h"
#import "SQLiteDatabase.h"
#import "ImageViewController.h"

@interface SaplingViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelCount;
@property (strong, nonatomic) IBOutlet UITextView *textViewEditSapling;
@property (strong, nonatomic) UIImage *image_1;
@property (strong, nonatomic) UIImage *image_2;
@property (strong, nonatomic) UIImage *image_3;
@property (nonatomic) int imageCount;

@end

@implementation SaplingViewController

@synthesize imagePickerController;
@synthesize buttonPlus;
@synthesize buttonImage_1;
@synthesize buttonImage_2;
@synthesize buttonImage_3;

sqlite3 *db;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textTitle.delegate = self;
    [self.textViewEditSapling.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewEditSapling.layer setBorderWidth:2];
    self.textViewEditSapling.layer.cornerRadius = 5;
    self.textViewEditSapling.delegate = self;
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(25, 113, 60, 60);
    buttonPlus = imageButton;
    [buttonPlus setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    [buttonPlus addTarget:self
                    action:@selector(buttonTouchPlus:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPlus];
    
    if (imagePickerController == nil){
        UIImagePickerController *aImagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController = aImagePickerController;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.image_1 = nil;
    self.image_2 = nil;
    self.image_3 = nil;
    self.imageCount = 0;
}

- (void)buttonTouchPlus:(id)sender {
    if (self.imageCount < 3){
        [self.navigationController presentViewController:self.imagePickerController animated:YES completion:nil];
        self.imageCount = self.imageCount + 1;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"只能放3张图片哦"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)backgroundTap:(id)sender {
    [self.textTitle resignFirstResponder];
    [self.textViewEditSapling resignFirstResponder];
}

#pragma mark - Text View Delegate

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    NSInteger newTextLength = [textView.text length] - range.length + [text length];
    if (newTextLength > 250)
    {
        [database alertBox:@"错误"
                   message:@"树苗不能超过250厘米"
          withCancelButton:@"确认"];
        return NO;
    } else {
        self.labelCount.text = [NSString stringWithFormat:@"%i / 250", newTextLength];
        return YES;
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    NSInteger newTextLength = [textField.text length] - range.length + [string length];
    if (newTextLength > 30)
    {
        [database alertBox:@"错误"
                   message:@"标题不要太长哦"
          withCancelButton:@"确认"];
        return NO;
    } else {
        return YES;
    }

}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];

    switch (self.imageCount) {
        case 1:
            self.image_1 = [info objectForKey:UIImagePickerControllerOriginalImage];
            imageButton.frame = CGRectMake(95, 113, 60, 60);
            buttonImage_1 = imageButton;
            [buttonImage_1 setImage:self.image_1 forState:UIControlStateNormal];
            [buttonImage_1 addTarget:self
                            action:@selector(buttonTouchShow_1:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buttonImage_1];
            break;
        case 2:
            self.image_2 = [info objectForKey:UIImagePickerControllerOriginalImage];
            imageButton.frame = CGRectMake(165, 113, 60, 60);
            buttonImage_2 = imageButton;
            [buttonImage_2 setImage:self.image_2 forState:UIControlStateNormal];
            [buttonImage_2 addTarget:self
                            action:@selector(buttonTouchShow_2:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buttonImage_2];
            break;
        case 3:
            self.image_3 = [info objectForKey:UIImagePickerControllerOriginalImage];
            imageButton.frame = CGRectMake(235, 113, 60, 60);
            buttonImage_3 = imageButton;
            [buttonImage_3 setImage:self.image_3 forState:UIControlStateNormal];
            [buttonImage_3 addTarget:self
                            action:@selector(buttonTouchShow_3:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buttonImage_3];
            break;
        default:
            break;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonTouchShow_1:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_1;
    [self.navigationController pushViewController:IVC animated:YES];
}

- (void)buttonTouchShow_2:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_2;
    [self.navigationController pushViewController:IVC animated:YES];
}

- (void)buttonTouchShow_3:(id)sender {
    ImageViewController *IVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Image"];
    IVC.image = self.image_3;
    [self.navigationController pushViewController:IVC animated:YES];
}

#pragma mark - IBAction

- (IBAction)buttonUpdate:(id)sender {
    SQLiteDatabase *database = [[SQLiteDatabase alloc] init];
    sqlite3_stmt *statement;
    [database openOrCreateDatabase:@"SaplingInfo"];
    [database openOrCreateTable:@"Saplings"
               withDescriptions:@"saplingID INTEGER PRIMARY KEY, userName TEXT, saplingTitle TEXT, saplingContent TEXT, saplingDate TEXT, saplingTime TEXT, saplingImage_1 BLOB, 'saplingImage_2' BLOB, 'saplingImage_3' BLOB"];
    
    NSString *saplingTitle = self.textTitle.text;
    NSString *saplingContent = self.textViewEditSapling.text;
    NSDate *Date = [NSDate date];
    NSString *saplingTime = [[NSString alloc] initWithFormat:@"%@", Date];
    NSArray *arrayDate = [saplingTime componentsSeparatedByString:@" "];
    NSString *saplingDate = [arrayDate objectAtIndex:0];
    NSData *imageData_1 = UIImagePNGRepresentation(self.image_1);
    NSData *imageData_2 = UIImagePNGRepresentation(self.image_2);
    NSData *imageData_3 = UIImagePNGRepresentation(self.image_3);
    
    if (![saplingTitle isEqualToString:@""])
    {
        if(![saplingContent isEqualToString:@""])
        {
            NSString *sqlInsertSapling = @"INSERT INTO Saplings ('userName', 'saplingTitle', 'saplingContent', 'saplingDate', 'saplingTime', 'saplingImage_1', 'saplingImage_2', 'saplingImage_3') VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            if (sqlite3_prepare_v2(db, [sqlInsertSapling UTF8String], -1, &statement, NULL) == SQLITE_OK){
                sqlite3_bind_text(statement, 1, [self.loadedUserName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [saplingTitle UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [saplingContent UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [saplingDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [saplingTime UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 6, [imageData_1 bytes], [imageData_1 length], SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 7, [imageData_2 bytes], [imageData_2 length], SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 8, [imageData_3 bytes], [imageData_3 length], SQLITE_TRANSIENT);
                
                sqlite3_step(statement);
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [database alertBox:@"错误" message:@"数据库崩溃" withCancelButton:@"确认"];
            }
        } else {
            [database alertBox:@"错误" message:@"请输入想要种下的树苗" withCancelButton:@"确认"];
        }
    } else {
        [database alertBox:@"错误" message:@"请输入标题" withCancelButton:@"确认"];
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

@end
