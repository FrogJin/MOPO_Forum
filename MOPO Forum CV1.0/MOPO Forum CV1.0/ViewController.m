//
//  ViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-7-31.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "ViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonLogIn;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;

@end

@implementation ViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    [self.buttonLogIn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4]];
    [self.buttonSignUp setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4]];
}

#pragma mark - IBAction

- (IBAction)buttonLogIn:(id)sender {
    LogInViewController *LIVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogIn"];
    LIVC.title = @"登录";
    [self.navigationController pushViewController:LIVC animated:YES];
}

- (IBAction)buttonSignUp:(id)sender {
    SignUpViewController *SUVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUp"];
    SUVC.title = @"注册";
    [self.navigationController pushViewController:SUVC animated:YES];
}

@end
