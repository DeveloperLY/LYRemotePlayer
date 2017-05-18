//
//  NSURL+LYAdd.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/18.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (LYAdd)

/**
 获取streaming协议的url地址
 */
- (NSURL *)streamingURL;

- (NSURL *)httpURL;

@end
