//
//  THWatchViewController.m
//  简单的直播小demo
//
//  Created by TH on 2016/11/9.
//  Copyright © 2016年 TH. All rights reserved.
//

#import "THWatchViewController.h"

@interface THWatchViewController ()
@property (weak, nonatomic) IBOutlet UIView *watchView;
@property (nonatomic,strong) id <IJKMediaPlayback> player;
@property (atomic, strong) NSURL *url;
@end

@implementation THWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = [NSURL URLWithString:@"rtmp://ams.studytv.cn/live/aaa"];
    //
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    UIView *playerView = [_player view];
    playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 49);
   
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.watchView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
  
    
    [self.player prepareToPlay];
    
    [self.player play];

    
    // Do any additional setup after loading the view.
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
