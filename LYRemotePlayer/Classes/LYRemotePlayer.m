//
//  LYRemotePlayer.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/14.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "LYRemoteResourceLoaderDelegate.h"
#import "NSURL+LYAdd.h"

@interface LYRemotePlayer ()

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

/** 是否是用户主动暂停 */
@property (nonatomic, assign, getter=isUserPause) BOOL userPause;

/** 资源加载代理 */
@property (nonatomic, strong) LYRemoteResourceLoaderDelegate *resourceLoaderDelegate;

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
- (void)playWithURL:(NSURL *)url isCache:(BOOL)isCache {
    NSURL *currentURL = ((AVURLAsset *) self.player.currentItem.asset).URL;
    if ([url isEqual:currentURL] || [[url streamingURL] isEqual:currentURL]) {
        [self resume];
        return;
    }
    // 当前音频资源的总时长
    if (self.player.currentItem) {
        [self removeObserver];
    }
    
    _url = url;
    if (isCache) {
        url = [url streamingURL];
    }
    
    // 资源的请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    self.resourceLoaderDelegate = [LYRemoteResourceLoaderDelegate new];
    [asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
    
    // 资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    // 资源的播放
    self.player = [AVPlayer playerWithPlayerItem:item];
}

- (void)pause {
    [self.player pause];
    self.userPause = YES;
    if (self.player) {
        _state = LYRemotePlayerStatePause;
    }
}

- (void)resume {
    [self.player play];
    self.userPause = NO;
    
    // 当前存在播放器且数据组织者已经准备好资源数据
    if (self.player && self.player.currentItem.isPlaybackLikelyToKeepUp) {
        _state = LYRemotePlayerStatePlaying;
    }
}

- (void)stop {
    [self.player pause];
    self.player = nil;
    if (self.player) {
        _state = LYRemotePlayerStateStopped;
    }
}

- (void)seekWithProgress:(CGFloat)progress {
    if (progress < 0 || progress > 1) {
        return;
    }
    // 当前音频资源的总时长
    CMTime totalTime = self.player.currentItem.duration;
    
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    NSTimeInterval playTimeSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(playTimeSec, 1);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"加载这个时间点的音频资源");
        } else {
            NSLog(@"取消加载这个时间点的音频资源");
        }
    }];
}

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    // 当前音频资源的总时长
    NSTimeInterval totalTimeSec = [self totalTime];
    
    // 当前音频, 已经播放的时长
    NSTimeInterval playTimeSec = [self currentTime];
    playTimeSec += timeDiffer;
    
    [self seekWithProgress:playTimeSec / totalTimeSec];
}


#pragma mark - Setter
- (void)setRate:(CGFloat)rate {
    [self.player setRate:rate];
}

- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0 || volume > 1) {
        return;
    }
    if (volume > 0) {
        [self setMuted:NO];
    }
    self.player.volume = volume;
}

#pragma mark - Private
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playEnd {
    NSLog(@"播放结束...");
    _state = LYRemotePlayerStateStopped;
}

- (void)playInterupt {
    // 中断
    NSLog(@"播放被中断...");
    _state = LYRemotePlayerStatePause;
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
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL pltku = [change[NSKeyValueChangeNewKey] boolValue];
        if (pltku) {
            // 用户的主动暂停优先级最高
            if (!self.isUserPause) {
                [self resume];
            } else {
                
            }
            
        } else {
            NSLog(@"资源加载中...");
            _state = LYRemotePlayerStateLoading;
        }
        
        
    }
}

#pragma mark - Getter
- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.currentTime / 60, (NSInteger)self.currentTime % 60];
}

- (NSString *)totalTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.totalTime / 60, (NSInteger)self.totalTime % 60];
}


- (NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}

- (NSTimeInterval)currentTime {
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}

- (CGFloat)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}


- (CGFloat)loadDataProgress {
    if (self.totalTime == 0) {
        return 0;
    }
    
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    
    return loadTimeSec / self.totalTime;
}


/**
 获取速率

 @return 速率
 */
- (CGFloat)rate {
    return self.player.rate;
}


/**
 是否静音

 @return 是否静音
 */
- (BOOL)muted {
    return self.player.muted;
}


/**
 当前声音大小

 @return 声音大小
 */
- (CGFloat)volume {
    return self.player.volume;
}


@end
