//
//  NSURL+LYAdd.m
//  LYRemotePlayer
//
//  Created by LiuY on 2017/5/18.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "NSURL+LYAdd.h"

@implementation NSURL (LYAdd)

- (NSURL *)streamingURL {
    // http://xxxx
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"sreaming";
    return compents.URL;
    
    
}

- (NSURL *)httpURL {
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"http";
    return compents.URL;
}

@end
