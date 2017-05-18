//
//  LYRemotePlayer.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/14.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LYRemotePlayerState) {
    LYRemotePlayerStateUnknown  = 0,        // 未知
    LYRemotePlayerStateLoading  = 1,        // 正在加载
    LYRemotePlayerStatePlaying  = 2,        // 正在播放
    LYRemotePlayerStateStopped  = 3,        // 停止
    LYRemotePlayerStatePause    = 4,        // 暂停
    LYRemotePlayerStateFailed   = 5         // 失败
};

@interface LYRemotePlayer : NSObject

@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat rate;


@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;


@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, readonly) CGFloat loadDataProgress;


@property (nonatomic, assign, readonly) LYRemotePlayerState state;




+ (instancetype)shareInstance;

- (void)playWithURL:(NSURL *)url;

- (void)pause;

- (void)resume;

- (void)stop;

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;

- (void)seekWithProgress:(CGFloat)progress;

@end
