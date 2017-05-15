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

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"];
    [[LYRemotePlayer shareInstance] playWithURL:url];
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

@end
