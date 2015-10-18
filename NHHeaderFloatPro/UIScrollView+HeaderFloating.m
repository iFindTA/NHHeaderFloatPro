//
//  UIScrollView+HeaderFloating.m
//  NHHeaderFloatPro
//
//  Created by hu jiaju on 15-10-18.
//  Copyright (c) 2015年 Nanhu. All rights reserved.
//

#import "UIScrollView+HeaderFloating.h"
#import <objc/runtime.h>

static void * NHFloatingHeaderViewKey = &NHFloatingHeaderViewKey;
static void * NHFloatingHeaderViewContext = &NHFloatingHeaderViewContext;
static void * NHFloatingHeaderViewHeight = &NHFloatingHeaderViewHeight;

@implementation UIScrollView (HeaderFloating)

#pragma mark - Setters/Getters
-(UIView *)floatingHeaderView{
    return objc_getAssociatedObject(self, NHFloatingHeaderViewKey);
}

-(void)setFloatingHeaderView:(UIView *)headerView{
    [self _handlePreviousHeaderView];
    
    objc_setAssociatedObject(self, NHFloatingHeaderViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self _handleNewHeaderView];
}

- (void)setFloatingHeight:(NSNumber *)FloatingHeight {
    objc_setAssociatedObject(self, NHFloatingHeaderViewHeight, FloatingHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)FloatingHeight{
    return objc_getAssociatedObject(self, NHFloatingHeaderViewHeight);
}

#pragma mark - Handle add/remove of views;
-(void)_handlePreviousHeaderView{
    UIView* previousHeaderView = [self floatingHeaderView];
    if(previousHeaderView != nil){
        UIEdgeInsets contentInset = [self contentInset];
        UIEdgeInsets scrollInset = [self scrollIndicatorInsets];
        contentInset.top-=previousHeaderView.frame.size.height;
        scrollInset.top-=previousHeaderView.frame.size.height;
        [self setContentInset:contentInset];
        [self setScrollIndicatorInsets:scrollInset];
        [previousHeaderView removeFromSuperview];
        @try {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        @catch (NSException * __unused exception) {
            
        }
        previousHeaderView = nil;
        
    }
}
-(void)_handleNewHeaderView{
    if(self.floatingHeaderView!=nil){
        [self addSubview:self.floatingHeaderView];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NHFloatingHeaderViewContext];
        [self.floatingHeaderView setFrame:CGRectMake(0, -self.floatingHeaderView.frame.size.height, self.frame.size.width, self.floatingHeaderView.frame.size.height)];
        UIEdgeInsets contentInset = [self contentInset];
        UIEdgeInsets scrollInset = [self scrollIndicatorInsets];
        contentInset.top+=self.floatingHeaderView.frame.size.height;
        scrollInset.top+=self.floatingHeaderView.frame.size.height;
        [self setContentInset:contentInset];
        [self setScrollIndicatorInsets:scrollInset];
        [self setContentOffset:CGPointMake(0, -self.floatingHeaderView.frame.size.height)];
    }
}

#pragma mark - Scroll Logic
/*
 * Three scrollStates:
 * - Fast Swipe up + header not visible = start showing the header
 * - Header is showing at least part of itself: scroll it by the content offset difference (with a maximum of the top offset)
 * - Header is completely showing = header should not scroll any more
 */
-(void)_scrolledFromOffset:(CGFloat)oldYOffset toOffset:(CGFloat)newYOffset{
    CGPoint scrollVelocity = [[self panGestureRecognizer] velocityInView:self];
    BOOL fastSwipe = NO;
    if(abs(scrollVelocity.y)>1000){
        fastSwipe = YES;
    }
    BOOL isHeaderShowing = self.floatingHeaderView.frame.origin.y+self.floatingHeaderView.frame.size.height>=newYOffset;
    BOOL isHeaderCompletelyShowing = self.floatingHeaderView.frame.origin.y >= oldYOffset;
    
    if(fastSwipe && !isHeaderShowing && oldYOffset>newYOffset){
        CGFloat difference = oldYOffset-newYOffset;
        CGRect floatingFrame = self.floatingHeaderView.frame;
        floatingFrame.origin.y = newYOffset - floatingFrame.size.height + difference;
        if(floatingFrame.origin.y>newYOffset)
            floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
    }
    if(isHeaderShowing){
        CGFloat difference = oldYOffset-newYOffset;
        CGRect floatingFrame = self.floatingHeaderView.frame;
        //floatingFrame.origin.y = floatingFrame.origin.y  + difference;
        if(floatingFrame.origin.y>newYOffset)
            floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
    }
    if(isHeaderCompletelyShowing && newYOffset<-self.floatingHeaderView.frame.size.height){
        CGRect floatingFrame = self.floatingHeaderView.frame;
        floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
        
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if (context == NHFloatingHeaderViewContext) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat oldYOffset = [[change objectForKey:@"old"]CGPointValue].y;
            CGFloat newYOffset = [[change objectForKey:@"new"]CGPointValue].y;
            [self _scrolledFromOffset:oldYOffset toOffset:newYOffset];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeContentOffsetObserver {
    [self removeObserver:self forKeyPath:@"contentOffset" context:NHFloatingHeaderViewContext];
}

@end
