//
//  MenuNavigationBar.m
//  MOPO Forum CV1.0
//
//  Created by Tim Jin on 15-8-9.
//  Copyright (c) 2015年 MOPO. All rights reserved.
//

#import "MenuNavigationBar.h"

@implementation MenuNavigationBar

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height = 65.f;
    
    return amendedSize;
}

@end
