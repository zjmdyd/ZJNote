//
//  ZJIconBadgeButton.m
//  ZJTest
//
//  Created by ZJ on 2019/4/25.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJIconBadgeButton.h"

@interface ZJIconBadgeButton ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) id target;

@end

@implementation ZJIconBadgeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = frame.size;
        CGFloat width = 20;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(size.width-width/2, -width/2+2, width, width)];
        self.label.font = [UIFont systemFontOfSize:11];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label setCornerRadius:width/2];
        [self addSubview:self.label];
    }
    return self;
}

+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target {
    ZJIconBadgeButton *btn = [[ZJIconBadgeButton alloc] initWithFrame:frame];
    if (target) {
        [btn addTarget:target action:NSSelectorFromString(@"badgeBtnEvent:") forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}

- (void)setBadgeTitle:(NSString * _Nonnull)badgeTitle badgeBgColor:(UIColor *)color {
    self.badgeTitle = badgeTitle;
    self.badgeBgColor = color;
}

- (void)setBadgeTitle:(NSString *)badgeTitle {
    _badgeTitle = badgeTitle;
    
    self.label.text = _badgeTitle;
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor {
    _badgeBgColor = badgeBgColor;
    
    self.label.backgroundColor = _badgeBgColor;
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    
    self.label.textColor = _badgeTitleColor;
}

- (void)setHidesBadge:(BOOL)hidesBadge {
    _hidesBadge = hidesBadge;
    
    self.label.hidden = _hidesBadge;
}

- (void)setAttrText:(NSAttributedString *)badgeAttrText {
    _badgeAttrText = badgeAttrText;
    
    self.label.attributedText = _badgeAttrText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
