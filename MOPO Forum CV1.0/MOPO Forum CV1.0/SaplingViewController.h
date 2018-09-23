//
//  SaplingViewController.h
//  Forum
//
//  Created by Tim Jin on 15-7-20.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SaplingViewController : UIViewController <UITextViewDelegate,
                                                    UITextFieldDelegate, 
                                                    UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickerController;
}

@property (strong, nonatomic) NSString *loadedUserName;
@property (retain, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlus;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_1;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_2;
@property (strong, nonatomic) IBOutlet UIButton *buttonImage_3;

@end
