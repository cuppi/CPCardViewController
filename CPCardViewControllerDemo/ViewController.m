//
//  ViewController.m
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/7/25.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "ViewController.h"
#import "CPCardView.h"
#import "UIImageView+WebCache.h"
#import "CardCell.h"

@interface ViewController () <CPCardViewDelegate>
{
    NSArray <NSString *>*_smallImageUrls;
    NSArray <NSString *>*_bigImageUrls;
    CPCardView *_cardView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createMetadata];
    [self createCardViewController];

    
}

- (void)createMetadata
{
    _smallImageUrls = @[ [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image1.jpg"],
                         [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image2.jpg"],
                         [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image3.jpg"],
                         [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image4.jpg"]];
    _bigImageUrls = @[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image1.jpg"],
                      [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image2.jpg"],
                      [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image3.jpg"],
                      [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"image4.jpg"]];
}

- (void)createCardViewController
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    // vc 目前只能使用全局变量。因为内部代理问题 
    _cardView = [[CPCardView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 200) withImageViewWidth:screenWidth*0.6 withImageViewHeight:200*0.7 withZoomScale:0.7];
    [self.view addSubview:_cardView];
    _cardView.delegate = self;
    _cardView.autoScrollToClickIndex = YES;
    [_cardView registerClass:[CardCell class] forCellReuseIdentifier:@"CardCell"];
    [_cardView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CPCardViewController delegate
- (NSInteger)numberOfUrlInCPCardView:(CPCardView *)cardView
{
    return _smallImageUrls.count*3;
}

- (NSURL *)CPCardView:(CPCardView *)cardView backUrlAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_bigImageUrls[index%_bigImageUrls.count]];
}

- (void)CPCardView:(CPCardView *)cardView fillCell:(CPCardCell *)cell AtIndex:(NSInteger)index
{
    [cell.imageView sd_setImageWithURL:[NSURL fileURLWithPath:_smallImageUrls[index%4]] placeholderImage:nil];
}

- (void)CPCardView:(CPCardView *)cardView didClickIndex:(NSInteger)index isSelectedIndex:(BOOL)isSelectedIndex
{
     [cardView setSelectedIndex:index withAnimation:YES];
}

- (void)CPCardView:(CPCardView *)cardView didSelectedIndex:(NSInteger)index
{
 //   NSLog(@"selected");
}

@end
