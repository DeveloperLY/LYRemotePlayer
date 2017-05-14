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


@end
