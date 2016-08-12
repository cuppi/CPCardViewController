//
//  CPCardCell.h
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/8/12.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCardCell : UIView
@property (readonly, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGFloat cp_maxWidth;
@property (assign, nonatomic) CGFloat cp_maxHeight;

@property (readonly, nonatomic) CGFloat maxWidth;
@property (readonly, nonatomic) CGFloat maxHeight;
- (void)layoutCardSubviews;
@end
