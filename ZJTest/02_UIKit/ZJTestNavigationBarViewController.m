//
//  ZJTestNavigationBarViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/2.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNavigationBarViewController.h"

@interface ZJTestNavigationBarViewController ()

@property (nonatomic, strong) UIColor *originColor;

@end

@implementation ZJTestNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettiing];
}

- (void)initSettiing {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    scrollView.alwaysBounceVertical = YES;
    [scrollView setBorderWidth:2 color:[UIColor blackColor]];
    [self.view addSubview:scrollView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    view.backgroundColor = [UIColor redColor];
    [scrollView addSubview:view];
    
    NSLog(@"%s", __func__);
    NSLog(@"self.navigationController = %@", self.navigationController);
    NSLog(@"navigationItem = %@", self.navigationItem);
    NSLog(@"navigationItem.backBarButtonItem = %@", self.navigationItem.backBarButtonItem);
}

- (void)getNavigationBarSubviews {
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        NSLog(@"view = %@, backgroundColor = %@", view, view.backgroundColor);
        for (UIView *subView in view.subviews) {
            NSLog(@"-->subView = %@, backgroundColor = %@", subView, subView.backgroundColor);
            for (UIView *subView2 in subView.subviews) {
                NSLog(@"---->subView2 = %@, backgroundColor = %@", subView2, subView2.backgroundColor);
                if ([subView2 isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")]) {
                    self.originColor = subView2.backgroundColor;
                    NSLog(@"self.originColor = %@", self.originColor);
                }
            }
        }
        NSLog(@"\n");
    }
}

/* iOS12 默认navigationBar
 1. translucent为YES时的子视图:
 2019-04-02 17:41:44.071536+0800 ZJTest[2026:699932] view = <_UIBarBackground: 0x10090fe80; frame = (0 0; 375 44); userInteractionEnabled = NO; layer = <CALayer: 0x283f3f360>>, backgroundColor = (null)
 2019-04-02 17:41:44.072209+0800 ZJTest[2026:699932] -->subView = <UIImageView: 0x100910310; frame = (0 44; 375 0.333333); userInteractionEnabled = NO; layer = <CALayer: 0x283f3f3a0>>, backgroundColor = UIExtendedSRGBColorSpace 0 0 0 0.3
 2019-04-02 17:41:44.072539+0800 ZJTest[2026:699932] -->subView = <UIVisualEffectView: 0x100910540; frame = (0 0; 375 44); layer = <CALayer: 0x283f3f3c0>>, backgroundColor = (null)
 2019-04-02 17:41:44.072871+0800 ZJTest[2026:699932] ---->subView2 = <_UIVisualEffectBackdropView: 0x1009148f0; frame = (0 0; 375 44); autoresize = W+H; userInteractionEnabled = NO; layer = <UICABackdropLayer: 0x283f3ff00>>, backgroundColor = (null)
 2019-04-02 17:41:44.073515+0800 ZJTest[2026:699932] ---->subView2 = <_UIVisualEffectSubview: 0x100915440; frame = (0 0; 375 44); autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x283f33f00>>, backgroundColor = UIExtendedGrayColorSpace 0.97 0.8
 2019-04-02 17:41:44.073572+0800 ZJTest[2026:699932]
 2019-04-02 17:41:44.073868+0800 ZJTest[2026:699932] view = <_UINavigationBarLargeTitleView: 0x100911830; frame = (0 0; 0 0); clipsToBounds = YES; hidden = YES; layer = <CALayer: 0x283f3f6e0>>, backgroundColor = (null)
 2019-04-02 17:41:44.074390+0800 ZJTest[2026:699932] -->subView = <UILabel: 0x10080dde0; frame = (0 0; 0 0); userInteractionEnabled = NO; layer = <_UILabelLayer: 0x281c2b4d0>>, backgroundColor = UIExtendedGrayColorSpace 0 0
 2019-04-02 17:41:44.074445+0800 ZJTest[2026:699932]
 2019-04-02 17:41:44.074820+0800 ZJTest[2026:699932] view = <_UINavigationBarContentView: 0x100910970; frame = (0 0; 375 44); layer = <CALayer: 0x283f3f440>>, backgroundColor = (null)
 2019-04-02 17:41:44.074998+0800 ZJTest[2026:699932] -->subView = <UILabel: 0x100903710; frame = (0 0; 0 0); text = 'Fondation'; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x281c31db0>>, backgroundColor = UIExtendedGrayColorSpace 0 0
 2019-04-02 17:41:44.075070+0800 ZJTest[2026:699932]
 2019-04-02 17:41:44.075567+0800 ZJTest[2026:699932] view = <_UINavigationBarModernPromptView: 0x100913980; frame = (0 0; 0 0); alpha = 0; hidden = YES; layer = <CALayer: 0x283f3fb40>>, backgroundColor = (null)
 2019-04-02 17:41:44.075613+0800 ZJTest[2026:699932]
 */

/*
 2.translucent为NO时的子视图:
 2019-04-02 18:01:21.132708+0800 ZJTest[2043:703093] view = <_UIBarBackground: 0x100e08850; frame = (0 0; 375 44); userInteractionEnabled = NO; layer = <CALayer: 0x28020ff40>>, backgroundColor = UIExtendedGrayColorSpace 1 1
 2019-04-02 18:01:21.133169+0800 ZJTest[2043:703093] -->subView = <UIImageView: 0x100e08ce0; frame = (0 44; 375 0.333333); userInteractionEnabled = NO; layer = <CALayer: 0x28020ff80>>, backgroundColor = UIExtendedSRGBColorSpace 0 0 0 0.3
 2019-04-02 18:01:21.133216+0800 ZJTest[2043:703093]
 2019-04-02 18:01:21.133526+0800 ZJTest[2043:703093] view = <_UINavigationBarLargeTitleView: 0x100d10ef0; frame = (0 0; 0 0); clipsToBounds = YES; hidden = YES; layer = <CALayer: 0x280206f80>>, backgroundColor = (null)
 2019-04-02 18:01:21.133869+0800 ZJTest[2043:703093] -->subView = <UILabel: 0x100d15400; frame = (0 0; 0 0); userInteractionEnabled = NO; layer = <_UILabelLayer: 0x28210b660>>, backgroundColor = UIExtendedGrayColorSpace 0 0
 2019-04-02 18:01:21.133907+0800 ZJTest[2043:703093]
 2019-04-02 18:01:21.134237+0800 ZJTest[2043:703093] view = <_UINavigationBarContentView: 0x100e09340; frame = (0 0; 375 44); layer = <CALayer: 0x280202340>>, backgroundColor = (null)
 2019-04-02 18:01:21.134455+0800 ZJTest[2043:703093] -->subView = <UILabel: 0x100d0c170; frame = (0 0; 0 0); text = 'Fondation'; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x2821009b0>>, backgroundColor = UIExtendedGrayColorSpace 0 0
 2019-04-02 18:01:21.134488+0800 ZJTest[2043:703093]
 2019-04-02 18:01:21.134905+0800 ZJTest[2043:703093] view = <_UINavigationBarModernPromptView: 0x100d1b910; frame = (0 0; 0 0); alpha = 0; hidden = YES; layer = <CALayer: 0x280218ce0>>, backgroundColor = (null)
 2019-04-02 18:01:21.134955+0800 ZJTest[2043:703093]
 */

/*
 结论:
 1.当translucent = YES;(默认值)，_UIBarBackground的子视图UIVisualEffectView有二级子视图_UIVisualEffectBackdropView和_UIVisualEffectSubview,且_UIVisualEffectSubviewa有背景色
 2.当translucent = NO,_UIBarBackground无二级子视图，_UIBarBackground有背景色
 3.当translucent为YES，控制器view从（0，0）开始；translucent为NO，控制器view从（0，64）开始,当控制器包含scrollView时，tableView会自动调整顶部坐标
 4.当设置navigationBar的setBackgroundImage方法时(设置clearColor除外,设置clearColor会使translucent值为YES),会改变navigationBar的translucent属性,默认的YES变成NO，
 5.当用户显性设置navigationBar.translucent属性值时，navigationBar的setBackgroundImage方法不影响navigationBar的translucent属性
 6.直接设置navigationBar背景色不起作用
 */

/*
 iOS11
 1: _UIBarBackground
 2: UIImageView
 2: UIVisualEffectView
 3: _UIVisualEffectBackdropView
 3: _UIVisualEffectSubview
 1: _UINavigationBarLargeTitleView
 2: UILabel
 1: _UINavigationBarContentView
 1: _UINavigationBarModernPromptView
 2: UILabel
 
 iOS10:
 1: _UIBarBackground
 2: UIImageView
 2: UIVisualEffectView
 3: _UIVisualEffectBackdropView
 3: _UIVisualEffectFilterView
 1: _UINavigationBarBackIndicatorView
 
 iOS9
 1: _UINavigationBarBackground
 2: _UIBackdropView
 3: _UIBackdropEffectView
 3: UIView
 2: UIImageView
 1: _UINavigationBarBackIndicatorView
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"\n");
    NSLog(@"%s", __func__);
    NSLog(@"self.navigationController = %@", self.navigationController);
    NSLog(@"topItem = %@", self.navigationController.navigationBar.topItem);
    NSLog(@"backItem = %@", self.navigationController.navigationBar.backItem);
    NSLog(@"navigationItem = %@", self.navigationItem);
    NSLog(@"navigationItem.backBarButtonItem = %@", self.navigationItem.backBarButtonItem);
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    NSLog(@"navigationBar.translucent = %d", self.navigationController.navigationBar.translucent);
    NSLog(@"\n");
    [self getNavigationBarSubviews];
}

/**
 2019-04-02 18:45:47.338922+0800 ZJTest[2097:711747] items = (
 "<UINavigationItem: 0x127e18560> title='UIKit'"
 )
 2019-04-02 18:45:47.339030+0800 ZJTest[2097:711747] topItem = <UINavigationItem: 0x127e18560> title='UIKit'
 2019-04-02 18:45:47.339074+0800 ZJTest[2097:711747] backItem = (null)
 2019-04-02 18:45:47.339261+0800 ZJTest[2097:711747] self.navigationItem = <UINavigationItem: 0x127d23bb0> title='UINavigationBar'
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    NSLog(@"topItem = %@", self.navigationController.navigationBar.topItem);
    NSLog(@"backItem = %@", self.navigationController.navigationBar.backItem);
    NSLog(@"navigationItem = %@", self.navigationItem);
    NSLog(@"navigationItem.backBarButtonItem = %@", self.navigationItem.backBarButtonItem);
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    
    NSLog(@"topViewController = %@", self.navigationController.topViewController);
    NSLog(@"visibleViewController = %@", self.navigationController.visibleViewController);
}
/*
 2019-04-12 16:29:44.141645+0800 ZJTest[5537:102314] topViewController     = <ZJTestNavigationBarViewController: 0x7f9799095800>
 2019-04-12 16:29:44.141762+0800 ZJTest[5537:102314] visibleViewController = <ZJTestNavigationBarViewController: 0x7f9799095800>
 */
/**
 2019-04-02 18:45:47.898658+0800 ZJTest[2097:711747] -[ZJTestNavigationBarViewController viewDidAppear:]
 2019-04-02 18:45:47.899203+0800 ZJTest[2097:711747] items = (
 "<UINavigationItem: 0x127e18560> title='UIKit'",
 "<UINavigationItem: 0x127d23bb0> title='UINavigationBar'"
 )
 2019-04-02 18:45:47.899364+0800 ZJTest[2097:711747] topItem = <UINavigationItem: 0x127d23bb0> title='UINavigationBar'
 2019-04-02 18:45:47.899544+0800 ZJTest[2097:711747] backItem = <UINavigationItem: 0x127e18560> title='UIKit'
 2019-04-02 18:45:47.899747+0800 ZJTest[2097:711747] self.navigationItem = <UINavigationItem: 0x127d23bb0> title='UINavigationBar'
 */

/*
 结论:
 1.控制器的navigationController属性要在viewWillAppear才有
 2.控制器的navigationItem属性值在viewDidAppear已经有了
 3.navigationBar.items要在viewDidAppear方法里面才加载完
 4.self.navigationItem.backBarButtonItem默认为null，要想改变返回按钮其实要改变的是父控制器的navigationItem.backBarButtonItem
 5.self.navigationController.navigationBar.backItem和父控制器的navigationItem.backBarButtonItem不是一个回事，父控制器的navigationItem.backBarButtonItem改变不影响navigationBar.backItem
   self.navigationController.navigationBar.backItem可以看成是父控制器的导航栏的标题view
   父控制器的navigationItem.backBarButtonItem其实就是返回按钮
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
