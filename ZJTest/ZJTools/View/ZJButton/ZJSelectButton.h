//
//  ZJSelectButton.h
//  ButlerSugar
//
//  Created by ZJ on 2/26/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSelectButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame selectImg:(NSString *)selectName unSelectImg:(NSString *)unselectName;

@property (nonatomic, getter=isSelect) BOOL select;
@property (nonatomic, assign) BOOL isSetImage;

@property (nonatomic, copy) NSString *unSelectTitle;
@property (nonatomic, copy) NSString *selectTitle;

@property (nonatomic, copy) NSString *selectImgName;
@property (nonatomic, copy) NSString *unSelectImgName;
@property (nonatomic, strong) UIImage *selectImg;
@property (nonatomic, strong) UIImage *unSelectImg;

@end
