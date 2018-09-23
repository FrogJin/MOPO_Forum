//
//  NavigationBarDrawer.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-11-25.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "NavigationBarDrawer.h"

#define kAnimationDuration 0.3

@implementation NavigationBarDrawer {
    UINavigationBar *parentBar;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, 320, 44)];
    return self;
}

- (void)setup {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:lineView];
    
    NSDictionary *views = @{@"line" : lineView};
    NSDictionary *metrics = @{@"width" : @(1.0 / [UIScreen mainScreen].scale)};
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(width)]|" options:0 metrics:metrics views:views]];
	
	_visible = NO;
}

- (void)setScrollView:(UIScrollView *)scrollView {
	if (_scrollView != scrollView) {
		_scrollView = scrollView;
	}
}

- (CGRect)finalFrameForNavigationBar:(UINavigationBar *)bar {
	CGRect rect = CGRectMake(bar.frame.origin.x,
							 bar.frame.origin.y + bar.frame.size.height,
							 bar.frame.size.width,
							 self.frame.size.height);
	return rect;
}

- (CGRect)initialFrameForNavigationBar:(UINavigationBar *)bar {
	CGRect rect = [self finalFrameForNavigationBar:bar];
	rect.origin.y -= rect.size.height;
	return rect;
}

- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated {
	
	parentBar = bar;
	if (!parentBar) {
		NSLog(@"Cannot display navigation bar from nil.");
		return;
	}
	
	[bar.superview insertSubview:self belowSubview:bar];
    
	if (animated) {
		self.frame = [self initialFrameForNavigationBar:bar];
	}

	CGFloat height = self.frame.size.height;
	CGFloat visible = _scrollView.bounds.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
	CGFloat diff = visible - _scrollView.contentSize.height;
	CGFloat fix = MAX(0.0, MIN(height, diff));

	UIEdgeInsets insets = _scrollView.contentInset;
	insets.top += height;
	_scrollView.contentInset = insets;
	_scrollView.scrollIndicatorInsets = insets;
	_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y + fix);
	
	void (^animations)() = ^void() {
		self.frame = [self finalFrameForNavigationBar:bar];
		_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y - height);
	};
	
	void (^completion)(BOOL) = ^void(BOOL finished) {
		_visible = YES;
	};
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
	
}

- (void)hideAnimated:(BOOL)animated {
	if (!parentBar) {
		NSLog(@"Navigation bar should not be released while drawer is visible.");
		return;
	}
	
	CGFloat height = self.frame.size.height;
	CGFloat visible = _scrollView.bounds.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
	CGFloat fix = height;
	if (visible <= _scrollView.contentSize.height) {
		CGFloat bottom = -_scrollView.contentOffset.y + _scrollView.contentSize.height;
		CGFloat diff = bottom - _scrollView.bounds.size.height + _scrollView.contentInset.bottom;
		fix = MAX(0.0, MIN(height, diff));
	}
	CGFloat offset = height - (_scrollView.contentOffset.y + _scrollView.contentInset.top);
	CGFloat topFix = MAX(0.0, MIN(height, offset));

	UIEdgeInsets insets = _scrollView.contentInset;
	insets.top -= height;
	_scrollView.contentInset = insets;
	_scrollView.scrollIndicatorInsets = insets;
	_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y - topFix);
	
	void (^animations)() = ^void() {
		self.frame = [self initialFrameForNavigationBar:parentBar];
		_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y + fix);
		
	};
	
	void (^completion)(BOOL) = ^void(BOOL finished) {
		_visible = NO;
		[self removeFromSuperview];
	};
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

@end
