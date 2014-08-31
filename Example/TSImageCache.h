//
//  ExampleImageCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache.h"
#import <UIKit/UIKit.h>

@interface TSImageCache : TSFileCache

+ (instancetype)sharedInstance;

- (UIImage *)imageForKey:(NSString *)key;
- (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
- (NSString *)cacheImageForUndefinedKey:(UIImage *)image store:(BOOL)store;
- (void)clear;


#pragma mark - unavailable
+ (void)setSharedInstance:(TSFileCache *)instance __TSFileCacheUnavailable__;
+ (instancetype)cacheForURL:(NSURL *)directoryURL __TSFileCacheUnavailable__;
+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL __TSFileCacheUnavailable__;
- (NSData *)dataForKey:(NSString *)key __TSFileCacheUnavailable__;
- (void)writeDataOnDisk:(NSData *)data forKey:(NSString *)key __TSFileCacheUnavailable__;

@end

@interface TSImageCache (Subscript)

- (void)setObject:(UIImage *)image forKeyedSubscript:(NSString *)key;
- (UIImage *)objectForKeyedSubscript:(NSString *)key;

@end
