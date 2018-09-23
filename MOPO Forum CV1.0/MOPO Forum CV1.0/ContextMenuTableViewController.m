//
//  ContextMenuTableViewController.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-9.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "ContextMenuTableViewController.h"
#import "MenuNavigationBar.h"
#import "MenuTableCell.h"

@interface ContextMenuTableViewController ()

@property (nonatomic, strong) NSArray *menuContexts;
@property (nonatomic, strong) NSArray *menuIcons;

@end

@implementation ContextMenuTableViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuContexts = @[@"",
                        @"生成验证码"];
    self.menuIcons = @[[UIImage imageNamed:@"Close"],
                       [UIImage imageNamed:@"Plus"]];
    [self.navigationController setValue:[[MenuNavigationBar alloc] init] forKeyPath:@"navigationBar"];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.menuContexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableCell *cell = (MenuTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuTableCell"];
    if (cell){
        cell.backgroundColor = [UIColor clearColor];
        cell.labelContext.text = [self.menuContexts objectAtIndex:indexPath.row];
        cell.imageViewIcon.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath){
        [tableView removeFromSuperview];
        return;
    }
}

- (void)addSubViewiew:(UIView *)view
withSidesConstrainsInsets:(UIEdgeInsets)insets {
    NSParameterAssert(view);
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:insets.top]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:insets.left]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:insets.bottom]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:insets.right]];
}

@end
