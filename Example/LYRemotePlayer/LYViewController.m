//
//  LYViewController.m
//  LYRemotePlayer
//
//  Created by DeveloperLY on 05/12/2017.
//  Copyright (c) 2017 DeveloperLY. All rights reserved.
//

#import "LYViewController.h"
#import <LYRemotePlayer/LYRemotePlayer.h>

@interface LYViewController ()

@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *ProgressView;

@property (weak, nonatomic) IBOutlet UIProgressView *playProgressView;

@property (nonatomic, weak) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *mutedButton;

@end

@implementation LYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self timer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    NSLog(@"%zd", [LYRemotePlayer shareInstance].state);
    self.playTimeLabel.text =  [LYRemotePlayer shareInstance].currentTimeFormat;
    self.totalTimeLabel.text = [LYRemotePlayer shareInstance].totalTimeFormat;
    
    self.ProgressView.value = [LYRemotePlayer shareInstance].progress;
    
    self.playProgressView.progress = [LYRemotePlayer shareInstance].loadDataProgress;
    
    self.mutedButton.selected = [LYRemotePlayer shareInstance].muted;
    
    
}

- (IBAction)play:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"];
    [[LYRemotePlayer shareInstance] playWithURL:url isCache:YES];
}


- (IBAction)pause:(UIButton *)sender {
    [[LYRemotePlayer shareInstance] pause];
}


- (IBAction)resume:(UIButton *)sender {
    [[LYRemotePlayer shareInstance] resume];
}


- (IBAction)speed:(UIButton *)sender {
    [[LYRemotePlayer shareInstance] seekWithTimeDiffer:10.0f];
}

- (IBAction)rate:(UIButton *)sender {
    [[LYRemotePlayer shareInstance] setRate:2.0f];
}


- (IBAction)muted:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[LYRemotePlayer shareInstance] setMuted:sender.selected];
}

- (IBAction)volume:(UISlider *)sender {
    [[LYRemotePlayer shareInstance] setVolume:sender.value];
}

- (IBAction)progress:(UISlider *)sender {
    [[LYRemotePlayer shareInstance] setVolume:sender.value];
}


- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

@end
