//
//  LYRemoteResourceLoaderDelegate.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/20.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYRemoteResourceLoaderDelegate.h"
#import "LYCacheFileTools.h"
#import "LYDownLoaderTools.h"
#import "NSURL+LYAdd.h"

@interface LYRemoteResourceLoaderDelegate () <LYDownLoaderToolsDelegate>

@property (nonatomic, strong) LYDownLoaderTools *downLoader;

@property (nonatomic, strong) NSMutableArray *loadingRequests;

@end

@implementation LYRemoteResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 本地有没有该资源的缓存文件
    NSURL *url = [loadingRequest.request.URL httpURL];
    
    int64_t requestOffset = loadingRequest.dataRequest.requestedOffset;
    int64_t currentOffset = loadingRequest.dataRequest.currentOffset;
    if (requestOffset != currentOffset) {
        requestOffset = currentOffset;
    }
    
    if ([LYCacheFileTools cacheFileExists:url]) {
        [self handleLoadingRequest:loadingRequest];
        return YES;
    }
    
    // 保存所有的请求
    [self.loadingRequests addObject:loadingRequest];
    
    // 判断有没有正在下载
    if (self.downLoader.loadedSize == 0) {
        [self.downLoader downLoadWithURL:url offset:requestOffset];
        return YES;
    }
    
    // 判断当前是否需要重新下载
    if (requestOffset < self.downLoader.offset || requestOffset > (self.downLoader.offset + self.downLoader.loadedSize + 888)) {
        [self.downLoader downLoadWithURL:url offset:requestOffset];
        return YES;
    }
    
    // 开始处理资源请求
    [self handleAllLoadingRequest];
    return YES;
}

// 取消请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self.loadingRequests removeObject:loadingRequest];
}


#pragma mark - LYDownLoaderToolsDelegate
- (void)downLoading {
    [self handleAllLoadingRequest];
}


- (void)handleAllLoadingRequest {
    NSMutableArray *deleteRequests = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequests) {
        // 填充内容信息头
        NSURL *url = loadingRequest.request.URL;
        int64_t totalSize = self.downLoader.totalSize;
        loadingRequest.contentInformationRequest.contentLength = totalSize;
        NSString *contentType = self.downLoader.mimeType;
        loadingRequest.contentInformationRequest.contentType = contentType;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
        // 填充数据
        NSData *data = [NSData dataWithContentsOfFile:[LYCacheFileTools tmpFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
        if (!data) {
            data = [NSData dataWithContentsOfFile:[LYCacheFileTools cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
        }
        
        int64_t requestOffset = loadingRequest.dataRequest.requestedOffset;
        int64_t currentOffset = loadingRequest.dataRequest.currentOffset;
        if (requestOffset != currentOffset) {
            requestOffset = currentOffset;
        }
        NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
        
        
        int64_t responseOffset = requestOffset - self.downLoader.offset;
        int64_t responseLength = MIN(self.downLoader.offset + self.downLoader.loadedSize - requestOffset, requestLength) ;
        
        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        
        [loadingRequest.dataRequest respondWithData:subData];
        
        // 完成请求
        if (requestLength == responseLength) {
            [loadingRequest finishLoading];
            [deleteRequests addObject:loadingRequest];
        }
    }
    [self.loadingRequests removeObjectsInArray:deleteRequests];
}

#pragma mark - Private Method
// 处理本地已经下载好的资源文件
- (void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSURL *url = loadingRequest.request.URL;
    int64_t totalSize = [LYCacheFileTools cacheFileSize:url];
    loadingRequest.contentInformationRequest.contentLength = totalSize;
    
    NSString *contentType = [LYCacheFileTools contentType:url];
    loadingRequest.contentInformationRequest.contentType = contentType;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    // 将相应数据传递给外面
    NSData *data = [NSData dataWithContentsOfFile:[LYCacheFileTools cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
    int64_t requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    [loadingRequest.dataRequest respondWithData:subData];
    
    // 完成本次请求
    [loadingRequest finishLoading];
}

#pragma mark - Getter
- (LYDownLoaderTools *)downLoader {
    if (!_downLoader) {
        _downLoader = [[LYDownLoaderTools alloc] init];
        _downLoader.delegate = self;
    }
    return _downLoader;
}


- (NSMutableArray *)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}

@end
