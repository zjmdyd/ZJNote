//
//  ZJRecorderViewController.m
//  ZJFoundation
//
//  Created by ZJ on 9/19/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZJRecorderViewController ()<AVAudioRecorderDelegate> {
    BOOL _isFinishRecord;
}

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;    //音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;        //音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;                    //录音声波监控（注意这里暂时不对播放进行监控）
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

#define kRecordAudioFile @"myRecord.caf"

@implementation ZJRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  录音 设置音频会话
 */
- (void)setStartAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  播放 设置音频会话
 */
- (void)setEndAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

- (IBAction)recordClick:(UIButton *)sender {
    _isFinishRecord = NO;

    if (!self.audioRecorder.isRecording) {
        [self setStartAudioSession];
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];     // 随机返回一个比较遥远的过去时间
    }else {
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];   // 随机返回一个比较遥远的未来时间
    }
    
    NSArray *titles = @[@"Record", @"Pause"];
    [sender setTitle:titles[self.audioRecorder.isRecording] forState:UIControlStateNormal];
}

- (IBAction)stopRecord:(UIButton *)sender {
    if (_isFinishRecord) {
        [self.audioPlayer play];
    }else {
        [self.audioRecorder stop];
    }
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (![self.audioPlayer isPlaying]) {
        [self setEndAudioSession];
        [self.audioPlayer play];
    }
    _isFinishRecord = YES;
    NSLog(@"录音完成!");
}

/**
 *  录音声波状态设置
 */
- (void)audioPowerChange {
    // 更新测量值
    [self.audioRecorder updateMeters];
    
    // 取得第一个通道的音频，注意音频强度范围时-160到0
    float power = [self.audioRecorder averagePowerForChannel:0];
    CGFloat progress = (power + 160.0) / 160.0;
    [self.progress setProgress:progress];
    NSLog(@"power = %f", power);
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
- (NSURL *)getSavePath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:urlStr]) {    // 如果不存在
        NSLog(@"xxx.txt is not exist");
    }else {
        NSLog(@"xxx.txt is  exist");
    }
    
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    
    return dicM;
}

#pragma mark - getter

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        // 创建录音文件保存路径
        NSURL *url = [self getSavePath];
        
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;   // 如果要监控声波则必须设置为YES
    }
    
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSURL *url = [self getSavePath];
        NSError *error=nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
- (NSTimer *)timer {
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
        self.audioRecorder = nil;
    }
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
