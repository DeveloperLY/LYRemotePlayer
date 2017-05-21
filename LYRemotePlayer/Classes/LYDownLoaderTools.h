//
//  LYDownLoaderTools.h
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/20.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYDownLoaderToolsDelegate <NSObject>

- (void)downLoading;

@end

@interface LYDownLoaderTools : NSObject

@property (nonatomic, assign) int64_t totalSize;
@property (nonatomic, assign) int64_t loadedSize;
@property (nonatomic, assign) int64_t offset;
@property (nonatomic, strong) NSString *mimeType;

@property (nonatomic, weak) id<LYDownLoaderToolsDelegate> delegate;

- (void)downLoadWithURL:(NSURL *)url offset:(int64_t)offset;

@end
