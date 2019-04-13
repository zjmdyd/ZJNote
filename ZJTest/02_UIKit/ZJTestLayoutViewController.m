//
//  ZJTestLayoutViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/13.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLayoutViewController.h"

@interface ZJTestLayoutViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation ZJTestLayoutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        NSLog(@"%s", __func__);
    }
    
    return self;
}

/*
 用xib布局最好用scrollView来实现，不用考虑适配导航栏，scrollView会自动从导航栏之下开始页面布局
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.alwaysBounceVertical = YES;
    [self.scrollView setBorderWidth:2 color:[UIColor blackColor]];
    
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.testView.frame));
    NSLog(@"mainScreen = %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.testView.frame));
}

- (void)viewWillLayoutSubviews {
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.testView.frame));
}

- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.testView.frame));
}

/*
 在这个方法里通过约束布局的self.testView的frame才最终确定
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.testView.frame));
}

/*
 initWithNibName    如果是xib加载控制器会调用
 viewDidLoad
 viewWillAppear
 myview updateConstraints //子视图updateContrains先调用
 updateViewConstraints
 viewWillLayoutSubviews
 viewDidLayoutSubviews
 viewDidAppear
 ---------------------
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
