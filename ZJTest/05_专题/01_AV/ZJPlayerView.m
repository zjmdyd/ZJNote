//
//  ZJPlayerView.m
//  ZJFoundation
//
//  Created by ZJ on 9/19/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJPlayerView.h"

@implementation ZJPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
