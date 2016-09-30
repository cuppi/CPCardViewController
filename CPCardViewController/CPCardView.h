//
//  CPCardView.h
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/9/30.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCardCell.h"

@class CPCardView;

@protocol CPCardViewDelegate <NSObject>

- (void)CPCardView:(CPCardView *)cardView
          fillCell:(CPCardCell *)cell
           AtIndex:(NSInteger)index;

- (NSURL *)CPCardView:(CPCardView *)cardView
       backUrlAtIndex:(NSInteger)index;

- (NSInteger)numberOfUrlInCPCardView:(CPCardView *)cardView;

@optional

// 编码格式不会调用这个方法
// 与上次一样将不会再调用 如果希望调用 请调用 CPCardViewController:didScrollToIndex:
- (void)CPCardView:(CPCardView *)cardView
  didSelectedIndex:(NSInteger)index;

- (void)CPCardView:(CPCardView *)cardView
 willScrollToIndex:(NSInteger)index
   isSelectedIndex:(BOOL)isSelectedIndex;

- (void)CPCardView:(CPCardView *)cardView
  didScrollToIndex:(NSInteger)index;

- (void)CPCardView:(CPCardView *)cardView
     didClickIndex:(NSInteger)index
   isSelectedIndex:(BOOL)isSelectedIndex;

@end

@interface CPCardView : UIView

@property (assign, nonatomic) BOOL autoScrollToClickIndex;
@property (assign, nonatomic) BOOL showPageControl;
@property (assign, nonatomic) id<CPCardViewDelegate> delegate;
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
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
- (void)setSelectedIndex:(NSInteger)selectedIndex
           withAnimation:(BOOL)animation;

@end
