//
//  ZJAboutView.h
//  CanShengHealth
//
//  Created by ZJ on 26/01/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJAboutView;

@protocol ZJAboutViewDelegate <NSObject>

- (void)aboutViewSelected:(ZJAboutView *)view;

@end

@interface ZJAboutView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *placeholdIcon;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat widthConst;   // 默认为100
@property (nonatomic, assign) CGFloat centerConst;  // 默认为-20
@property (nonatomic, assign) CGFloat titleTopConst;    // 默认为8

@property (nonatomic, weak) id<ZJAboutViewDelegate> delegate;

@end
