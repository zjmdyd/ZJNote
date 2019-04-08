//
//  ZJPullDownButton.m
//  KeerZhineng
//
//  Created by ZJ on 2018/11/6.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJPullDownButton.h"

@interface ZJPullDownButton ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *iv;

@end

@implementation ZJPullDownButton

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title color:[UIColor blackColor]];
}

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color {
    self = [super init];
    if (self) {
        self.title = title;
        self.titleColor = color;
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.text = self.title;
    self.label.textColor = self.titleColor;
    [self addSubview:self.label];
    
    self.iv = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iv.image = [UIImage imageNamed:@"ic_xiala_30x30"];
    [self addSubview:self.iv];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    
    [self resetFrame];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.label.text = _title;
    
    [self resetFrame];
}

- (void)resetFrame {
    CGSize size = [UILabel fitSizeWithHeight:21 text:self.label.text];
    self.label.frame = CGRectMake(0, 0, size.width, 30);
    self.iv.frame = CGRectMake(self.label.frame.size.width + self.label.frame.origin.x + 2, 0, 20, 20);
    self.iv.center = CGPointMake(self.iv.center.x, self.label.center.y);
    self.frame = CGRectMake(0, 0, size.width + self.iv.frame.size.width + 2, self.label.frame.size.height);
    self.btn.frame = self.bounds;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    self.label.textColor = _titleColor;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    self.iv.image = [UIImage imageNamed:_imageName];
}

- (void)setRotation:(CGFloat)rotation {
    _rotation = rotation;
    
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.iv.transform = CGAffineTransformMakeRotation(weakSelf->_rotation);
    }];
}

- (void)btnEvent:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(pullDownButton:didClickButtonAtIndex:)]) {
        [self.delegate pullDownButton:self didClickButtonAtIndex:0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
