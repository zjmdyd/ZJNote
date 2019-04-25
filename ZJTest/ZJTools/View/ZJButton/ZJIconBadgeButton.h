//
//  ZJIconBadgeButton.h
//  ZJTest
//
//  Created by ZJ on 2019/4/25.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJIconBadgeButton : UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target;

// badge
@property (nonatomic, copy) NSString *badgeTitle;
@property (nonatomic, strong) UIColor *badgeBgColor;
@property (nonatomic, strong) UIColor *badgeTitleColor; // 默认为白色

@property (nonatomic, strong) NSAttributedString *badgeAttrText;
@property (nonatomic, assign) BOOL hidesBadge;

- (void)setBadgeTitle:(NSString * _Nonnull)badgeTitle badgeBgColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
