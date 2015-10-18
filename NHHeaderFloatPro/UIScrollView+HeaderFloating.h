//
//  UIScrollView+HeaderFloating.h
//  NHHeaderFloatPro
//
//  Created by hu jiaju on 15-10-18.
//  Copyright (c) 2015年 Nanhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HeaderFloating)

@property (nonatomic, strong) UIView* floatingHeaderView;

@property (nonatomic, strong) NSNumber *FloatingHeight;

-(void)removeContentOffsetObserver;

@end
