//
//  ZJVideoViewController.m
//  ZJFoundation
//
//  Created by ZJ on 9/26/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZJVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)       AVCaptureSession            *session;

//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)       AVCaptureDeviceInput        *videoInput;

//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong)       AVCaptureMovieFileOutput   *output;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  *previewLayer;

//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;

//放置预览图层的View
@property (weak, nonatomic) IBOutlet UIView *cameraShowView;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZJVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(toggleCamera)];
}

/**
 *  切换镜头的按钮方法
 */
- (IBAction)toggleCamera:(UIButton *)sender {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[self.videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            }else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

/**
 *  这是获取前后摄像头对象的方法
 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

/**
 *  拍照的方法
 */
- (IBAction)shutterCamera:(UIButton *)sender {
    AVCaptureConnection *videoConnection = [self.output connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    [self.shutterButton setTitle:@"停止" forState:UIControlStateNormal];

    //根据连接取得设备输出的数据
    if (![self.output isRecording]) {
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        videoConnection.videoOrientation = [self.previewLayer connection].videoOrientation;
        NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        NSLog(@"save path is :%@", outputFielPath);
        NSURL *fileUrl = [NSURL fileURLWithPath:outputFielPath];
        [self.output startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
    else{
        [self.output stopRecording];//停止录制
        [self.shutterButton setTitle:@"拍摄" forState:UIControlStateNormal];
    }
}

#pragma mark - 视频输出代理

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    NSLog(@"outputFileURL = %@", outputFileURL);
    //视频录入完成之后在后台将视频存储到相簿
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        NSLog(@"成功保存视频到相簿.");
    }];
}

/**
 *  加载预览图层的方法
 */
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            NSLog(@"相机权限受限");
            return nil;
        }
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        NSLog(@"self.cameraShowView.bounds = %@", NSStringFromCGRect(self.cameraShowView.bounds));
        CGRect bounds = [view bounds];
        [_previewLayer setFrame:bounds];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    
    return _previewLayer;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
            _session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        
        // 输入设备对象
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
        
        // 输出数据对象
        self.output = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([_session canAddInput:self.videoInput]) {
            [_session addInput:self.videoInput];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    NSLog(@"self.cameraShowView.bounds = %@", NSStringFromCGRect(self.cameraShowView.bounds));
    if (self.session) {
        [self.session startRunning];
    }
    
    self.shutterButton.layer.cornerRadius = 60 / 2;
}
/**
 *  启动和关闭session
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_previewLayer) {
        [self.cameraShowView.layer addSublayer:self.previewLayer];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
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
