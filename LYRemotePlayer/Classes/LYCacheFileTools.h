//
//  LYCacheFileTools.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/20.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCacheFileTools : NSObject

+ (NSString *)cacheFilePath:(NSURL *)url;
+ (int64_t)cacheFileSize:(NSURL *)url;
+ (BOOL)cacheFileExists:(NSURL *)url;


+ (NSString *)tmpFilePath:(NSURL *)url;
+ (int64_t)tmpFileSize:(NSURL *)url;
+ (BOOL)tmpFileExists:(NSURL *)url;
+ (void)clearTmpFile:(NSURL *)url;


+ (NSString *)contentType:(NSURL *)url;

+ (void)moveTmpPathToCachePath:(NSURL *)url;

@end
