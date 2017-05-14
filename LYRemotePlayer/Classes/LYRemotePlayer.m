//
//  LYRemotePlayer.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/14.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface LYRemotePlayer ()

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation LYRemotePlayer

static LYRemotePlayer *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

#pragma mark - Public Method
- (void)playWithURL:(NSURL *)url {
    // 资源的请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    // 资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 资源的播放
    self.player = [AVPlayer playerWithPlayerItem:item];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"资源没有问题，可以播放资源");
            [self.player play];
        } else {
            NSLog(@"资源状态未知");
        }
    }
}

@end
