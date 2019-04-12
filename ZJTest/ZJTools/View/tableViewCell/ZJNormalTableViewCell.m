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
    if (self.iconCornerRadius > 0) {
        self.imageView.layer.cornerRadius = self.iconCornerRadius;
        self.imageView.layer.masksToBounds = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"%s", __func__);
    NSLog(@"imageView = %@", self.imageView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
