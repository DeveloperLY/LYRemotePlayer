//
//  LYCacheFileTools.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/20.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYCacheFileTools.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()

@implementation LYCacheFileTools

+ (NSString *)cacheFilePath:(NSURL *)url {
    return [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (int64_t)cacheFileSize:(NSURL *)url {
    if (![self cacheFileExists:url]) {
        return 0;
    }
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self cacheFilePath:url] error:nil];
    return  [fileInfoDict[NSFileSize] longLongValue];
}

+ (BOOL)cacheFileExists:(NSURL *)url {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self cacheFilePath:url]];
}



+ (NSString *)tmpFilePath:(NSURL *)url {
    return [kTmpPath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (int64_t)tmpFileSize:(NSURL *)url {
    if (![self tmpFileExists:url]) {
        return 0;
    }
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self tmpFilePath:url] error:nil];
    return  [fileInfoDict[NSFileSize] longLongValue];
}

+ (BOOL)tmpFileExists:(NSURL *)url {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self tmpFilePath:url]];
}

+ (void)clearTmpFile:(NSURL *)url {
    NSString *tmpPath = [self tmpFilePath:url];
    BOOL isDirectory = YES;
    BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDirectory];
    if (isEx && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
}



+ (NSString *)contentType:(NSURL *)url {
    NSString *fileExtension = [self cacheFilePath:url].pathExtension;
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    return contentType;
}


+ (void)moveTmpPathToCachePath:(NSURL *)url {
    [[NSFileManager defaultManager] moveItemAtPath:[self tmpFilePath:url] toPath:[self cacheFilePath:url] error:nil];
}

@end
