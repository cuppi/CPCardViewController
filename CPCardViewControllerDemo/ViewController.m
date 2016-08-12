//
//  ViewController.m
//  CPCardViewControllerDemo
//
//  Created by cuppi on 2016/7/25.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "ViewController.h"
#import "CPCardViewController.h"

@interface ViewController () <CPCardViewControllerDelegate>
{
    NSArray <NSString *>*_smallImageUrls;
    NSArray <NSString *>*_bigImageUrls;
    CPCardViewController *_vc;
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
    _vc = [[CPCardViewController alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 200) withImageViewWidth:screenWidth*0.8 withImageViewHeight:200*0.8 withZoomScale:0.7];
    [self.view addSubview:[_vc view]];
    _vc.delegate = self;
    [_vc reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CPCardViewController delegate
- (NSInteger)numberOfUrlInCPCardViewController:(CPCardViewController *)viewController
{
    return _smallImageUrls.count*3;
}

- (NSURL *)CPCardViewController:(CPCardViewController *)viewController frontUrlAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_smallImageUrls[index%_smallImageUrls.count]];
}

- (NSURL *)CPCardViewController:(CPCardViewController *)viewController backUrlAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_bigImageUrls[index%_bigImageUrls.count]];
}

- (void)CPCardViewController:(CPCardViewController *)viewController
            didSelectedIndex:(NSInteger)index
{
    NSLog(@"%ld 被选择", index + 1);
}

- (void)CPCardViewController:(CPCardViewController *)viewController
               didClickIndex:(NSInteger)index
             isSelectedIndex:(BOOL)isSelectedIndex
{
    if (isSelectedIndex) {
        NSLog(@"点击当前ImageView");
    }
    else
    {
        [viewController setSelectedIndex:index withAnimation:YES];
    }
}


@end
