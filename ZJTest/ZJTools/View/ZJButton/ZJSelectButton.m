//
//  ZJSelectButton.m
//  ButlerSugar
//
//  Created by ZJ on 2/26/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJSelectButton.h"

@implementation ZJSelectButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImage *image = self.select ? self.selectImg : self.unSelectImg;
    if (image) {
        if (self.isSetImage) {
            [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else {
            [self setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    NSString *str = self.select ? self.selectTitle : self.unSelectTitle;
    if (str.length) {
        [self setTitle:str forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame selectImg:(NSString *)selectName unSelectImg:(NSString *)unselectName {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectImgName = selectName;
        self.unSelectImgName = unselectName;
    }
    
    return self;
}

- (void)setSelectImgName:(NSString *)selectImgName {
    _selectImgName = selectImgName;
    
    self.selectImg = [UIImage imageNamed:_selectImgName];
}

- (void)setUnSelectImgName:(NSString *)unSelectImgName {
    _unSelectImgName = unSelectImgName;
    
    self.unSelectImg = [UIImage imageNamed:_unSelectImgName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
