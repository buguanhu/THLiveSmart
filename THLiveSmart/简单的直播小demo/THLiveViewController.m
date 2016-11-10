//
//  THLiveViewController.m
//  简单的直播小demo
//
//  Created by TH on 2016/11/9.
//  Copyright © 2016年 TH. All rights reserved.
//

#import "THLiveViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface THLiveViewController () <LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic,strong) LFLiveSession *session;
@end

@implementation THLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        //  [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头" delegate:self cancelButtonTitle:@"hh" otherButtonTitles:@"", nil] show];
        
        //     return NO;
    }
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            }
            else {
                
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头" delegate:self cancelButtonTitle:@"hh" otherButtonTitles:@"", nil] show];
                //    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                return NO;
            }
        }];
    }

    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    streamInfo.url = @"rtmp://ams.studytv.cn/live/aaa";
    
    [self.playBtn setTitle:@"直播" forState:UIControlStateNormal];
    
    [[self.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
      
        if (self.playBtn.selected == YES) {
        
            [self.playBtn setTitle:@"直播" forState:UIControlStateNormal];
            [self.session stopLive];
          //  [self.session setRunning:NO];
            self.playBtn.selected = NO;
      
        }else{
        
            
            [self.playBtn setTitle:@"停止" forState:UIControlStateNormal];
          // [self.session setRunning:YES];
            [self.session startLive:streamInfo];
            
            self.playBtn.selected = YES;
            
        }
        
    }];
    
    // Do any additional setup after loading the view.
}

- (LFLiveSession*)session{
    if(!_session){
   
        //音频配置
        LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
        audioConfiguration.numberOfChannels = 2;
        audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
        audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
    
        //视频配置
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
        videoConfiguration.videoSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height *2);
        videoConfiguration.videoBitRate = 800*1024;
        videoConfiguration.videoMaxBitRate = 1000*1024;
        videoConfiguration.videoMinBitRate = 500*1024;
        videoConfiguration.videoFrameRate = 15;
        videoConfiguration.videoMaxKeyframeInterval = 30;
        videoConfiguration.outputImageOrientation = UIDeviceOrientationPortrait;
        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
        
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration captureType:LFLiveCaptureMaskAll];
        
        _session.captureDevicePosition = AVCaptureDevicePositionBack;
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.liveView;
    }
    return _session;
}

- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange: (LFLiveState)state{
    
    NSLog(@"%lu",(unsigned long)state);
    
}
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
    NSLog(@"%@",debugInfo);
    
}
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
    NSLog(@"%lu",(unsigned long)errorCode);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
