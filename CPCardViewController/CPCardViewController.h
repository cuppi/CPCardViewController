//
//  CPCardViewController.h
//  CPCardViewController
//
//  Created by cuppi on 16/5/30.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SDWebImage/UIImageView+WebCache.h>

@class CPCardViewController;

@protocol CPCardViewControllerDelegate <NSObject>
- (NSURL *)CPCardViewController:(CPCardViewController *)viewController
                frontUrlAtIndex:(NSInteger)index;

- (NSURL *)CPCardViewController:(CPCardViewController *)viewController
                 backUrlAtIndex:(NSInteger)index;

- (NSInteger)numberOfUrlInCPCardViewController:(CPCardViewController *)viewController;

@optional
- (void)CPCardViewController:(CPCardViewController *)viewController
            didSelectedIndex:(NSInteger)index;

- (void)CPCardViewController:(CPCardViewController *)viewController
           willScrollToIndex:(NSInteger)index
             isSelectedIndex:(BOOL)isSelectedIndex;

- (void)CPCardViewController:(CPCardViewController *)viewController
               didClickIndex:(NSInteger)index
             isSelectedIndex:(BOOL)isSelectedIndex;

@end

@interface CPCardViewController : NSObject
@property (assign, nonatomic) id<CPCardViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedIndex;
- (instancetype)initWithFrame:(CGRect)frame
           withImageViewWidth:(CGFloat)imageViewWidth
          withImageViewHeight:(CGFloat)imageViewHeight
                withZoomScale:(CGFloat)zoomScale;
- (instancetype)initWithFrame:(CGRect)frame
           withImageViewWidth:(CGFloat)imageViewWidth
          withImageViewHeight:(CGFloat)imageViewHeight;
- (instancetype)initWithFrame:(CGRect)frame
                withZoomScale:(CGFloat)zoomScale;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData;
- (UIView *)view;
- (void)setSelectedIndex:(NSInteger)selectedIndex
           withAnimation:(BOOL)animation;
@end
