//
//  ZJTestLayerViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/7/10.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLayerViewController.h"

@interface ZJTestLayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ZJTestLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIView *testview = [[UIView alloc] initWithFrame:self.bgView.bounds];
//    [self.bgView addSubview: testview];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:testview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16,16)];
//    //创建 layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = testview.bounds;
//    //赋值
//    maskLayer.path = maskPath.CGPath;
//    testview.layer.mask = maskLayer;
//    maskLayer.borderWidth = 10;
//    maskLayer.borderColor = [UIColor greenColor].CGColor;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = shapeLayer;
    
//    CAShapeLayer *borderLayer=[CAShapeLayer layer];
//    borderLayer.path = maskPath.CGPath;
//    borderLayer.fillColor = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor = [UIColor redColor].CGColor;
//    borderLayer.lineWidth = 2;
//    borderLayer.frame = self.bgView.bounds;
//    [borderLayer setName:@"lit"];
//    [self.bgView.layer addSublayer:borderLayer];
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
