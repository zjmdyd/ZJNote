//
//  ZJTestScrollViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/8/5.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestScrollViewController.h"

@interface ZJTestScrollViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ZJTestScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *ary = @[@"iconmm_01", @"iconmm_02", @"iconmm_03"];
    for (int i = 0; i < ary.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenH)];
        iv.image = [UIImage imageNamed:ary[i]];
        [self.scrollView addSubview:iv];
    }
    [self.scrollView setContentSize:CGSizeMake(kScreenW*ary.count, 0)];
}

//只要滚动了就会触发

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll -> ContentOffset  x is  %f,yis %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

//完成拖拽

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
}

//将开始降速时

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating");
}

//减速停止了时执行，手触摸时执行执行

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
}

//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

//如果你不是完全滚动到滚轴视图的顶部，你可以轻点状态栏，那个可视的滚轴视图会一直滚动到顶部，那是默认行为，你可以通过该方法返回NO来关闭它

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewShouldScrollToTop");
    
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScrollToTop");
}

////设置放大缩小的视图，要是uiscrollview的subview
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
//
//{
//
//    NSLog(@"viewForZoomingInScrollView");
//
//    return viewA;
//
//}
//
////完成放大缩小时调用
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
//
//{
//
//    viewA.frame=CGRectMake(50,0, 100, 400);
//
//    NSLog(@"scale between minimum and maximum. called after any 'bounce' animations");
//
//}// scale between minimum and maximum. called after any 'bounce' animations

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
