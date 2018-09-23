//
//  NavigationBarDrawer.h
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-11-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarDrawer : UIToolbar

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) UIScrollView *scrollView;

- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
