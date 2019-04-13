//
//  ZJAboutView.m
//  CanShengHealth
//
//  Created by ZJ on 26/01/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJAboutView.h"

@interface ZJAboutView()

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;

@end

@implementation ZJAboutView

- (IBAction)btnEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(aboutViewSelected:)]) {
        [self.delegate aboutViewSelected:self];
    }
}

- (void)setDelegate:(id<ZJAboutViewDelegate>)delegate {
    _delegate = delegate;
    
    self.btn.userInteractionEnabled = _delegate != nil;
}

- (void)setCenterConst:(CGFloat)centerConst {
    _centerConst = centerConst;
    
    self.centerConstraint.constant = _centerConst;
}

- (void)setWidthConst:(CGFloat)widthConst {
    _widthConst = widthConst;
    
    self.widthConstraint.constant = _widthConst;
}

- (void)setTitleTopConst:(CGFloat)titleTopConst {
    _titleTopConst = titleTopConst;
    
    self.titleTopConstraint.constant = _titleTopConst;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;

    self.titleLabel.textColor = _titleColor;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    
    [self.btn setBackgroundImage:[UIImage imageNamed:_icon] forState:UIControlStateNormal];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
