//
//  ZJEditButton.m
//  KeerZhineng
//
//  Created by ZJ on 2018/11/30.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJEditButton.h"

@interface ZJEditButton ()

@property (nonatomic, strong) UIImageView *iv;

@end

@implementation ZJEditButton

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    
    if (_isEdit && !self.iv) {
        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-15, 0, 20, 20)];
        self.iv.image = [UIImage imageNamed:self.editIcon?:@""];
        [self addSubview:self.iv];
    }
    
    self.iv.hidden = !_isEdit;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
