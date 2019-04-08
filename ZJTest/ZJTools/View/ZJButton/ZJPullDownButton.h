//
//  ZJPullDownButton.h
//  KeerZhineng
//
//  Created by ZJ on 2018/11/6.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZJPullDownButton;

@protocol ZJPullDownButtonDelegate <NSObject>

- (void)pullDownButton:(ZJPullDownButton *)view didClickButtonAtIndex:(NSInteger)index;

@end

@interface ZJPullDownButton : UIView

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, weak) id<ZJPullDownButtonDelegate> delegate;
@property (nonatomic, assign) CGFloat rotation;

@end

NS_ASSUME_NONNULL_END
