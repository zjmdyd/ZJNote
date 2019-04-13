//
//  ZJNormalTableViewCell.m
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewCell.h"

@implementation ZJNormalTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.synchronSysFont) {
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.detailTextLabel.font = [UIFont systemFontOfSize:17];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.iconCornerRadius > 0) {
        self.imageView.layer.cornerRadius = self.iconCornerRadius;
        self.imageView.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
 2019-04-13 10:31:08.201358+0800 ZJTest[4817:1679904] -[ZJNormalTableViewCell initWithStyle:reuseIdentifier:] 此时控件的frame还没确定
 2019-04-13 10:31:08.274012+0800 ZJTest[4817:1679904] -[ZJNormalTableViewCell setSynchronSysFont:]
 2019-04-13 10:31:08.282615+0800 ZJTest[4817:1679904] -[ZJNormalTableViewCell layoutSubviews]   此时控件的frame已经确定 此方法每次页面显示都会调用
 2019-04-13 10:31:08.287870+0800 ZJTest[4817:1679904] -[ZJNormalTableViewCell drawRect:]    此方法默认只会调用一次，除非开发者自己调用刷新
 */
@end
