//
//  ZJAVPlayerViewController.m
//  ZJFoundation
//
//  Created by ZJ on 9/19/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZJPlayerView.h"

/**
 
	@abstract
 AVPlayer offers a playback(播放) interface for single-item playback that's sufficient for
 the implementation of playback controllers and playback user interfaces.
 
	@discussion
 AVPlayer works equally well with local and remote media files, providing clients with appropriate(适当的)
 information about readiness to play or about the need to await additional data before continuing.
 
 Visual content of items played by an instance of AVPlayer can be displayed in a CoreAnimation layer
 of class AVPlayerLayer.
 
 To allow clients to add and remove their objects as key-value observers safely, AVPlayer serializes(序列化) notifications of
 changes that occur dynamically during playback on a dispatch queue. By default, this queue is the main queue. See dispatch_get_main_queue().
 
 To ensure safe access to AVPlayer's nonatomic properties while dynamic changes in playback state may be reported, clients must
 serialize their access with the receiver's notification queue. In the common case, such serialization is naturally achieved
 by invoking AVPlayer's various methods on the main thread or queue.
 */
@interface ZJAVPlayerViewController () {
    AVPlayerLayer *_layer;
    NSString *_totalTime;
    id _playbackTimeObserver;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet ZJPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

NSString *AVPath = @"http://183.60.197.32/5/n/w/c/q/nwcqvlmfyhutxwhnjnmemyfvlfieyb/he.yinyuetai.com/2DC7014ECE4E573C6EF8D41496C515BB.flv?sc\\u003dbb9a6bf778028cc2\\u0026br\\u003d3145\\u0026vid\\u003d691897\\u0026aid\\u003d13377\\u0026area\\u003dKR\\u0026vst\\u003d0";


@implementation ZJAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gezaifei" ofType:@"mp4"];
    NSURL *url;
    if (path) {
        url = [NSURL fileURLWithPath:path];     // 本地视频
    }else {
        url = [NSURL URLWithString:AVPath];     // 网络视频
    }
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];           // 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 监听loadedTimeRanges属性
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView.player = self.player;
    
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

/**
 *  typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
	AVPlayerItemStatusUnknown,
	AVPlayerItemStatusReadyToPlay,
	AVPlayerItemStatusFailed
 };
 */

/**
 *  typedef NS_ENUM(NSInteger, AVPlayerStatus) {
	AVPlayerStatusUnknown,
	AVPlayerStatusReadyToPlay,
	AVPlayerStatusFailed
 };
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"keyPath = %@, change = %@", keyPath, change);

    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.playBtn.enabled = YES;
            
            // 获取视频总长度
            CMTime duration = self.playerItem.duration;
            
            // 转换成秒
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            
            // 转换成播放时间字符串
            _totalTime = [self convertTime:totalSecond];
            
            // 自定义UISlider外观
            [self customVideoSlider:duration];
            
            // 监听播放状态
            [self monitoringPlayback:self.playerItem];
        }else if ([playerItem status] == AVPlayerItemStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self.player play];
        NSTimeInterval timeInterval = [self availableDuration];                     // 计算缓冲进度
        CGFloat totalDuration = CMTimeGetSeconds(self.playerItem.duration);
        [self.progressView setProgress:timeInterval / totalDuration animated:YES];
    }
}

/**
 *  计算缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];    // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;                     // 计算缓冲总进度
    
    return result;
}

/**
 *  更改UISlide外观
 */
- (void)customVideoSlider:(CMTime)duration {
    self.slider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    _playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value / playerItem.currentTime.timescale;// 计算当前在第几秒
        self.slider.value = currentSecond;
        self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", [self convertTime:currentSecond], self->_totalTime];
    }];
}

- (IBAction)play:(UIButton *)sender {
    if (self.player.rate < FLT_EPSILON) {
        [self.player play];
    }else {
        [self.player pause];
    }
    NSArray *titles = @[@"play", @"pause"];
    [sender setTitle:titles[self.player.rate > FLT_EPSILON] forState:UIControlStateNormal];
}

- (IBAction)slider:(UISlider *)sender {
    [self.player seekToTime:CMTimeMake(sender.value, 1)];
}

/**
 *  时间转换成字符串
 */
- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }

    return [formatter stringFromDate:date];
}

/**
 *  播放结束通知
 */
- (void)moviePlayDidEnd:(NSNotification *)noti {
    NSLog(@"moviePlayDidEnd : %@", noti);
    [self.playBtn setTitle:@"play" forState:UIControlStateNormal];
    [self.player seekToTime:kCMTimeZero];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player pause];
    [self.player removeTimeObserver:_playbackTimeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

// https://zwo28.wordpress.com/2015/03/06/%E8%A7%86%E9%A2%91%E5%90%88%E6%88%90%E4%B8%ADcmtime%E7%9A%84%E7%90%86%E8%A7%A3%EF%BC%8C%E4%BB%A5%E5%8F%8A%E5%88%A9%E7%94%A8cmtime%E5%AE%9E%E7%8E%B0%E8%BF%87%E6%B8%A1%E6%95%88%E6%9E%9C/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
