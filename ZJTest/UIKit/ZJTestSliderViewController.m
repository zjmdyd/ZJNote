//
//  ZJTestSliderViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/27.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestSliderViewController.h"

@interface ZJTestSliderViewController ()

@end

@implementation ZJTestSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)touchCancel:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)touchDown:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)touchUpInside:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)touchUpOutside:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)dragOutSide:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)dragInside:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)dragExit:(UISlider *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)dragEnter:(UISlider *)sender {
    NSLog(@"%s", __func__);
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
