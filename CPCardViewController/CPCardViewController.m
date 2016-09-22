//
//  CPCardViewController.m
//  PrepareCode
//
//  Created by cuppi on 16/5/30.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPCardViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+WebCache.h"


typedef struct IntegerInterval {
    CGFloat left;
    CGFloat right;
}IntegerInterval;

@interface CPCardViewController () <UIScrollViewDelegate>
{
    
    // 主View frame
    CGRect _frame;
    // 主View
    UIView *_view;
    // 背景毛玻璃效果
    UIImageView *_blurImageView;
    // 主背景滑动视图
    UIScrollView *_mainScrollView;
    // 原点
    UIPageControl *_pageControl;
    
    NSInteger _count;
    // 滚动Cell 数组
    NSMutableArray <CPCardCell *>*_cardCellList;
    NSMutableDictionary <NSString *, Class>*_registerMap;
    
    CGFloat _imageViewWidth;
    CGFloat _imageViewHeight;
    // 第一张 和 最后一张 距离屏幕边缘的间距
    CGFloat _scrollSideSpace;
    CGFloat _zoomScale;
}
@end

@implementation CPCardViewController
#pragma mark -- 构造方法
- (instancetype)initWithFrame:(CGRect)frame
           withImageViewWidth:(CGFloat)imageViewWidth
          withImageViewHeight:(CGFloat)imageViewHeight
                withZoomScale:(CGFloat)zoomScale
{
    
    if (self = [super init]) {
        _frame = frame;
        _imageViewWidth = imageViewWidth;
        _imageViewHeight = imageViewHeight;
        _scrollSideSpace = (CGRectGetWidth(_frame) - imageViewWidth)/2;
        if (zoomScale > 0 && zoomScale < 1) {
            _zoomScale = zoomScale;
        }
        else
        {
            _zoomScale = 0.8;
        }
        [self createMetadata];
        [self createView];
        [self createBlurImageView];
        [self createScrollView];
        [self createPageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
           withImageViewWidth:(CGFloat)imageViewWidth
          withImageViewHeight:(CGFloat)imageViewHeight
{
    return [self initWithFrame:frame withImageViewWidth:imageViewWidth withImageViewHeight:imageViewHeight withZoomScale:0.8];
}

- (instancetype)initWithFrame:(CGRect)frame
                withZoomScale:(CGFloat)zoomScale
{
    return [self initWithFrame:frame withImageViewWidth:CGRectGetWidth(frame)*0.8 withImageViewHeight:CGRectGetWidth(frame)*0.8 withZoomScale:0.8];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withImageViewWidth:CGRectGetWidth(frame)*0.8 withImageViewHeight:CGRectGetWidth(frame)*0.8 withZoomScale:0.8];
}

- (instancetype)init
{
    NSAssert(0, @"不建议的初始化方法,  如果需要,  请将这条语句注释");
    return [self initWithFrame:CGRectZero withImageViewWidth:0 withImageViewHeight:0 withZoomScale:0];
}

#pragma mark -- 初始化方法
- (void)createMetadata
{
    _cardCellList = [NSMutableArray arrayWithCapacity:50];
    _registerMap = [NSMutableDictionary dictionary];
    _autoScrollToClickIndex = NO;
    _showPageControl = YES;
    _selectedIndex = 0;
}

- (void)createView
{
    _view = [[UIView alloc]initWithFrame:_frame];
    _view.clipsToBounds = YES;
}

- (void)createBlurImageView
{
    // 创建辅助imageView
    _blurImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_frame), CGRectGetHeight(_frame))];
    [_view addSubview:_blurImageView];
}

- (void)createScrollView
{
    // 创建主Scroll View
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_frame), CGRectGetHeight(_frame))];
    [_view addSubview:_mainScrollView];
    _mainScrollView.clipsToBounds = NO;
    // 添加代理
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_frame) - 40, CGRectGetWidth(_frame), 30)];
    [_view addSubview:_pageControl];
    _pageControl.currentPage = 0;
}

#pragma mark -- 接口函数
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [_registerMap setObject:cellClass forKey:identifier];
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _pageControl.hidden = !showPageControl;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex withAnimation:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
           withAnimation:(BOOL)animation
            callDelegate:(BOOL)callDelegate
{
    if (!self.delegate) {
        return;
    }
    if (selectedIndex >= [self.delegate numberOfUrlInCPCardViewController:self] ||
        selectedIndex < 0) {
        return;
    }
    _selectedIndex = selectedIndex;
    _pageControl.currentPage = selectedIndex;
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            _mainScrollView.contentOffset = CGPointMake(_imageViewWidth*selectedIndex, 0);
#warning 效率低
            for (UIView *cell in _cardCellList) {
                [cell layoutIfNeeded];
            }
        } completion:^(BOOL finished) {
            if (callDelegate && finished && [self.delegate respondsToSelector:@selector(CPCardViewController:didSelectedIndex:)]) {
                [self.delegate CPCardViewController:self didSelectedIndex:selectedIndex];
            }
        }];
    }
    else
    {
        _mainScrollView.contentOffset = CGPointMake(_imageViewWidth*selectedIndex, 0);
        if (callDelegate && [self.delegate respondsToSelector:@selector(CPCardViewController:didSelectedIndex:)]) {
            [self.delegate CPCardViewController:self didSelectedIndex:selectedIndex];
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
           withAnimation:(BOOL)animation
{
    [self setSelectedIndex:selectedIndex withAnimation:animation callDelegate:NO];
}

- (UIView *)view
{
    return _view;
}

- (void)reloadData
{
    _selectedIndex = 0;
    _mainScrollView.contentOffset = CGPointZero;
    if (!self.delegate) {
        return;
    }
    _count = [self.delegate numberOfUrlInCPCardViewController:self];
    if (_count <= 0) {
        return;
    }
    
    CGFloat selectedImageWidth = _imageViewWidth;
    CGFloat selectedImageHeight = _imageViewHeight;
    CGFloat zoomWidth = _zoomScale*selectedImageWidth;
    CGFloat zoomHeight = _zoomScale*selectedImageHeight;
    
    [_cardCellList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_cardCellList removeAllObjects];
    
    for (NSInteger i = 0; i < _count; i ++) {
        CPCardCell *cell = nil;
        if (_registerMap.count <= 0) {
            cell = [[CPCardCell alloc] init];
        }
        else
        {
            cell = [[_registerMap.allValues.firstObject alloc]init];
        }
        cell.frame = CGRectMake(_scrollSideSpace + _imageViewWidth*i, (CGRectGetHeight(_frame) - _imageViewHeight)/2, _imageViewWidth, _imageViewHeight);
        cell.cp_maxWidth = _imageViewWidth;
        cell.cp_maxHeight = _imageViewHeight;
        [_mainScrollView addSubview:cell];
        [_cardCellList addObject:cell];
        [self.delegate CPCardViewController:self fillCell:cell AtIndex:i];
        cell.tag = i;
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClickImage:)]];
        if (i != 0)
        {
            cell.bounds = CGRectMake(0, 0, zoomWidth, zoomHeight);
        }
    }
    _mainScrollView.contentSize = CGSizeMake(selectedImageWidth*_count + _scrollSideSpace*2 , 0);
    _pageControl.numberOfPages = _count;
    [self updateBlurImageView];
}


#pragma mark -- Update BackBlurImageView
- (void)updateBlurImageView
{
    if (!self.delegate) {
        return;
    }
    [_blurImageView sd_setImageWithURL:[self.delegate CPCardViewController:self backUrlAtIndex:_selectedIndex] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            [self animationImageView:_blurImageView toImage:[image applyBlurWithRadius:10 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil]];
        }
    }];
}

#pragma mark -- scrollView delegate
// 停止减速 可以理解为scrollView 停止运动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.delegate) {
        return;
    }
    // 如果用户手指还在scrollView上
    // 防止当用户拖拽到第一个之前或者最后一个之后 立刻停止滚动时 产生错误
    if (scrollView.tracking) {
        return;
    }
    
    // 获取当前照片
    NSInteger selectedIndex = [self displayIndexForOffsetX:_mainScrollView.contentOffset.x];
    // 避免当按到 -1 或者 count+1 的时候触发这个事件
    if (selectedIndex < 0 ||
        selectedIndex >= _count) {
        return;
    }
    BOOL isSameCell = _selectedIndex == selectedIndex;
    _selectedIndex = selectedIndex;
    _pageControl.currentPage = selectedIndex;
    
    [self updateBlurImageView];
    if ([self.delegate respondsToSelector:@selector(CPCardViewController:didScrollToIndex:)]) {
        [self.delegate CPCardViewController:self didScrollToIndex:selectedIndex];
    }
    if (!isSameCell && [self.delegate respondsToSelector:@selector(CPCardViewController:didSelectedIndex:)]) {
        [self.delegate CPCardViewController:self didSelectedIndex:_selectedIndex];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustImageViewSizeWhenScroll];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat needTargetOffsetX = scrollView.contentOffset.x + velocity.x*CGRectGetWidth([UIScreen mainScreen].bounds);
    if (needTargetOffsetX < 0) {
        [self willScrollToIndex:0];
        *targetContentOffset = CGPointMake(0, 0);
        return;
    }
    if (needTargetOffsetX > scrollView.contentSize.width - CGRectGetWidth(_frame)) {
        [self willScrollToIndex:[self.delegate numberOfUrlInCPCardViewController:self] - 1];
        *targetContentOffset = CGPointMake(scrollView.contentSize.width, 0);
        return;
    }
    
    CGFloat needTargetCenterX = needTargetOffsetX + CGRectGetWidth(_frame)/2;
    
    NSInteger pureOffsetX = nearbyintf(needTargetCenterX - _scrollSideSpace);
    NSInteger imageViewWidthInt = nearbyintf(_imageViewWidth);
    NSInteger preImageCount = pureOffsetX/imageViewWidthInt;
    NSInteger halfOffset = pureOffsetX%imageViewWidthInt;
    
    CGFloat actualTargetCenterX = 0;
    if (halfOffset > 0) {
        actualTargetCenterX = (preImageCount*_imageViewWidth + _imageViewWidth/2 + _scrollSideSpace);
    }
    else
    {
        actualTargetCenterX = (preImageCount*_imageViewWidth - _imageViewWidth/2 + _scrollSideSpace);
    }
    CGFloat actualTargetOffsetX = actualTargetCenterX - CGRectGetWidth(_frame)/2;
    [self willScrollToIndex:(NSInteger)nearbyintf(actualTargetOffsetX/_imageViewWidth)];
    *targetContentOffset = CGPointMake(actualTargetOffsetX, 0);
}

#pragma mark -- action area
- (void)actionClickImage:(UIGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag;
    if ([self.delegate respondsToSelector:@selector(CPCardViewController:didClickIndex:isSelectedIndex:)]) {
        [self.delegate CPCardViewController:self didClickIndex:index isSelectedIndex:index == _selectedIndex];
    }
    if (_autoScrollToClickIndex && index != _selectedIndex) {
        [self willScrollToIndex:index];
        [self setSelectedIndex:index withAnimation:YES callDelegate:YES];
    }
    
}


#pragma mark -- 私有方法
// 滚动时改变大小
- (void)adjustImageViewSizeWhenScroll
{
    _pageControl.currentPage = [self displayIndexForOffsetX:_mainScrollView.contentOffset.x];
    CGFloat selectedImageWidth = _imageViewWidth;
    CGFloat selectedImageHeight = _imageViewHeight;
    CGFloat scrollSideSpace = _scrollSideSpace;
    CGFloat zoomWidthBias = (1 - _zoomScale)*selectedImageWidth;
    CGFloat zoomHeightBias = (1 - _zoomScale)*selectedImageHeight;
    CGFloat offsetX = _mainScrollView.contentOffset.x;
    CGFloat windowOffset = (CGRectGetWidth(_frame) - selectedImageWidth)/2;
    
    for (NSInteger i = 0; i < _count; i++) {
        CPCardCell *cell = _cardCellList[i];
        //当前窗口范围为  offsetX ~ offsetX + selectedImageWidth
        IntegerInterval iWindow = {i*selectedImageWidth, (i + 1)*selectedImageWidth};
        IntegerInterval actWindow = {offsetX + windowOffset - scrollSideSpace, offsetX + selectedImageWidth + windowOffset - scrollSideSpace};
        BOOL isCross = [self isCrossBetween:iWindow with:actWindow];
        if (isCross)
        {
            CGFloat biasValue = fabs(iWindow.left - actWindow.left);
            CGFloat biasScaleValue = biasValue/selectedImageWidth;
            cell.bounds = CGRectMake(0, 0, selectedImageWidth - zoomWidthBias*biasScaleValue, selectedImageHeight - zoomHeightBias*biasScaleValue);
        }
        else
        {
            cell.bounds = CGRectMake(0, 0, _zoomScale*selectedImageWidth, _zoomScale*selectedImageHeight);
        }
    }
}
// 将要滚动到指定索引
- (void)willScrollToIndex:(NSInteger)index
{
    if (!(index >= 0 && index < [self.delegate numberOfUrlInCPCardViewController:self])) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(CPCardViewController:willScrollToIndex:isSelectedIndex:)]) {
        [self.delegate CPCardViewController:self willScrollToIndex:index isSelectedIndex:index == _selectedIndex];
    }
}

// 当前的显示索引
- (NSInteger)displayIndexForOffsetX:(CGFloat)offsetX
{
    NSInteger index = (NSInteger) nearbyint(offsetX/_imageViewWidth);
    if (index < _count) {
        return index;
    }
    return _count - 1;
}

- (BOOL)isCrossBetween:(IntegerInterval)integerInterval
                  with:(IntegerInterval)otherIntegerInterval
{
    if (integerInterval.left > otherIntegerInterval.right || otherIntegerInterval.left > integerInterval.right) {
        return NO;
    }
    return YES;
}

- (void)animationImageView:(UIImageView *)imageView
                   toImage:(UIImage *)image
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.removedOnCompletion = YES;
    [imageView.layer addAnimation:transition forKey:@""];
    imageView.image = image;
}

@end

