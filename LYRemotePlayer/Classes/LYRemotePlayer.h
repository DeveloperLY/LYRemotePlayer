//
//  LYRemotePlayer.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/14.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYRemotePlayer : NSObject

+ (instancetype)shareInstance;

- (void)playWithURL:(NSURL *)url;

- (void)pause;

- (void)resume;

- (void)stop;

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;

- (void)seekWithProgress:(CGFloat)progress;

- (void)setRate:(CGFloat)rate;

- (void)setMuted:(BOOL)muted;

- (void)setVolume:(CGFloat)volume;

@end
