//
//  SelfViewController.h
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-6.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfViewController : UIViewController <UITableViewDataSource,
                                                UITableViewDelegate,
                                                UINavigationControllerDelegate,
                                                UIImagePickerControllerDelegate>

@property (nonatomic,strong) NSArray *records;
@property (strong, nonatomic) NSString *loadedUserName;
@property (retain, nonatomic) UIImagePickerController *imagePickerController;

@end
