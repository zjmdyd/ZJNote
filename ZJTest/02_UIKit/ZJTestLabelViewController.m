//
//  ZJTestLabelViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/25.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLabelViewController.h"

@interface ZJTestLabelViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ZJTestLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(8, 100, 150, 30)];
    self.label.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    self.label.numberOfLines = 0;
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.alpha = 0.5;
    [self.label setBorderWidth:1 color:[UIColor blackColor]];
    [self.view addSubview:self.label];

    /*
     ** font匹配Label的size，当Label能放下当前文本时，不会改变Label的font 
     */
//    label.adjustsFontSizeToFitWidth = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:self.label.frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:self.label];
    
    /*
     ** size匹配Label的font，当Label能放下当前文本时，会裁剪size以得到适合Label的size
     ** 当文本超过当前的size时:
     ** 1. numberOfLines=0时, 会改变Label的height，而宽度不会超过原size的width
     ** 2. numberOfLines=1时, 会改变Label的width,高度将会适配1行的高度
     ** 3. numberOfLines>1时, 按照行数得到对应行数的高度，但不会超过numberOfLines文本的高度，宽度不会超过原size的width, 与[label fitSizeWithWidth:]得到的size一样大
     */
    [self.label sizeToFit];
//    NSLog(@"%@", NSStringFromCGRect(label.frame));
//
//    CGSize size = [label sizeThatFits:CGSizeMake(150, MAXFLOAT)];
//    NSLog(@"%@", NSStringFromCGSize(size));
    
    self.mutableValues = @[].mutableCopy;
    CGFloat btnWidth = 80, btnHeight = 30;
    for (int i = 0; i < 3; i++) {
        ZJSelectButton *btn = [[ZJSelectButton alloc] initWithFrame:CGRectMake(8 + i * (btnWidth+10), self.label.bottom + 30, btnWidth, btnHeight)];
        [btn setTitle:[NSString stringWithFormat:@"%d行", i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setBorderWidth:1 color:[UIColor blackColor]];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = [UIColor redColor];
        btn.unSelectImgName = @"ic_weixuanzhong_54x54";
        btn.selectImgName = @"ic_xuanzhong_54x54";
        btn.isSetImage = YES;
        btn.tag = i;
        btn.select = self.label.numberOfLines == i;
        [self.mutableValues addObject:btn];
        [self.view addSubview:btn];
    }
}

- (void)btnEvent:(ZJSelectButton *)sender {
    NSLog(@"sender = %@", sender);
    for (ZJSelectButton *btn in self.mutableValues) {
        NSLog(@"btn = %@, isEqual = %d", btn, [btn isEqual:sender]);
        btn.select = [btn isEqual:sender];
        [btn setNeedsLayout];
    }
    self.label.numberOfLines = sender.tag;
    [self.label sizeToFit];
    [self.label setNeedsDisplay];
//    [self.label setNeedsLayout];
//
//    [self.view setNeedsLayout];
//    [self.view setNeedsDisplay];
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
