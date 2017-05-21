//
//  LYDownLoaderTools.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/20.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYDownLoaderTools.h"
#import "LYCacheFileTools.h"

@interface LYDownLoaderTools () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSURL *url;

@end

@implementation LYDownLoaderTools

#pragma mark - Public Method
- (void)downLoadWithURL:(NSURL *)url offset:(int64_t)offset {
    [self cancelAndClean];
    
    self.url = url;
    self.offset = offset;
    
    // 请求某一个区间的数据 Range
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - Private Method
- (void)cancelAndClean {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    // 清空本地已经存储的临时缓存
    [LYCacheFileTools clearTmpFile:self.url];
    // 重置数据
    self.loadedSize = 0;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    self.totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    self.mimeType = response.MIMEType;
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[LYCacheFileTools tmpFilePath:self.url] append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    self.loadedSize += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(downLoading)]) {
        [self.delegate downLoading];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        NSURL *url = self.url;
        if ([LYCacheFileTools tmpFileSize:url] == self.totalSize) {
            [LYCacheFileTools moveTmpPathToCachePath:url];
        }
    } else {
        NSLog(@"下载出错...");
    }
}


#pragma mark - Getter
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
