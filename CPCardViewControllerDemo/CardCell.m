//
//  CardCell.m
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/8/12.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CardCell.h"

@implementation CardCell
{
    UIImageView *_topLeftImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell
{
    self.backgroundColor = [UIColor orangeColor];
    _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:_topLeftImageView];
    _topLeftImageView.image = [UIImage imageNamed:@"首页-预售"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutCardSubviews
{
    _topLeftImageView.frame = CGRectMake(0,
                                         0,
                                         60*(self.frame.size.width/self.maxWidth),
                                         60*(self.frame.size.height/self.maxHeight));
}

@end
