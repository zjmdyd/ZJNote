//
//  ZJTestCAGradientLayerViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/26.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestCAGradientLayerViewController.h"

@interface ZJTestCAGradientLayerViewController ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *colorView;

@end

@implementation ZJTestCAGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 60, 40)];
    self.bgView.center = CGPointMake(kScreenW/2, 100);
    [self.view addSubview:self.bgView];
    
    NSLog(@"self.bgView.frame = %@", NSStringFromCGRect(self.bgView.frame));
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bgView.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    self.gradientLayer.colors = @[
                                  (__bridge id)UIColorFromHex(0xff0000).CGColor,
                                  (__bridge id)UIColorFromHex(0xff00ff).CGColor,
                                  (__bridge id)UIColorFromHex(0x0000ff).CGColor,
                                  (__bridge id)UIColorFromHex(0x00ffff).CGColor,
                                  (__bridge id)UIColorFromHex(0x00ff00).CGColor,
                                  (__bridge id)UIColorFromHex(0xffff00).CGColor,
                                  (__bridge id)UIColorFromHex(0xff0000).CGColor
                                  ];
    [self.bgView.layer addSublayer:self.gradientLayer];
    
    CGRect frame = self.bgView.frame;
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 150, frame.size.width, 150)];
    self.colorView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.colorView];
}

- (UIColor *)colorOfPoint:(CGPoint)point {
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.gradientLayer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    NSLog(@"pixel: %d-->%d-->%d-->%d", pixel[0], pixel[1], pixel[2], pixel[3]);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *th = touches.allObjects.firstObject;
    CGPoint point = [th locationInView:self.bgView];
    UIColor *color = [self colorOfPoint:point];
    self.colorView.backgroundColor = color;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
