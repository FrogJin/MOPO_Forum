//
//  ImageViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-6.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

#pragma mark - View Controller

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor blackColor];
}

@end
