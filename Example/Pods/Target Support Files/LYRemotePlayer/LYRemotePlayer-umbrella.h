#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LYCacheFileTools.h"
#import "LYDownLoaderTools.h"
#import "LYRemotePlayer.h"
#import "LYRemoteResourceLoaderDelegate.h"
#import "NSURL+LYAdd.h"

FOUNDATION_EXPORT double LYRemotePlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char LYRemotePlayerVersionString[];

