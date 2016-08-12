//
//  CPCardCell.m
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/8/12.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPCardCell.h"

@implementation CPCardCell

- (instancetype)init
{
   return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cp_configureCell];
    }
    return self;
}

- (void)cp_configureCell
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (CGFloat)maxWidth
{
    return _cp_maxWidth;
}

- (CGFloat)maxHeight
{
    return _cp_maxHeight;
}

- (void)layoutSubviews
{
    _imageView.frame = self.bounds;
    [self layoutCardSubviews];
}

- (void)layoutCardSubviews
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
