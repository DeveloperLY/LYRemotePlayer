//
//  LYRemotePlayer.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/14.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

// 播放器的状态
typedef NS_ENUM(NSUInteger, LYRemotePlayerState) {
    LYRemotePlayerStateUnknown  = 0,        // 未知
    LYRemotePlayerStateLoading  = 1,        // 正在加载
    LYRemotePlayerStatePlaying  = 2,        // 正在播放
    LYRemotePlayerStateStopped  = 3,        // 停止
    LYRemotePlayerStatePause    = 4,        // 暂停
    LYRemotePlayerStateFailed   = 5         // 失败
};

@interface LYRemotePlayer : NSObject


/** 是否静音 */
@property (nonatomic, assign) BOOL muted;

/** 音量大小 */
@property (nonatomic, assign) CGFloat volume;

/** 当前播放的速率 */
@property (nonatomic, assign) CGFloat rate;


/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

/** 总时长（格式化） */
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;

/** 已经播放的时长 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

/** 已经播放的时长 (格式化) */
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;

/** 播放进度 */
@property (nonatomic, assign, readonly) CGFloat progress;

/** 当前播放的URL地址 */
@property (nonatomic, strong, readonly) NSURL *url;

/** 资源加载进度 */
@property (nonatomic, assign, readonly) CGFloat loadDataProgress;

/** 播放状态 */
@property (nonatomic, assign, readonly) LYRemotePlayerState state;



/**
 单例
 */
+ (instancetype)shareInstance;


/**
 根据URL地址播放远程的音频资源

 @param url URL地址
 */
- (void)playWithURL:(NSURL *)url;


/**
 暂停播放
 */
- (void)pause;


/**
 继续播放
 */
- (void)resume;


/**
 停止播放
 */
- (void)stop;


/**
 快进/快退

 @param timeDiffer 跳跃的时间段
 */
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;


/**
 播放指定的进度

 @param progress 指定进度
 */
- (void)seekWithProgress:(CGFloat)progress;

@end
