//
//  TSFileCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFileCache : NSObject

/// Set shared instance.
+ (void)setSharedInstance:(TSFileCache *)instance;

/// Get shared instance. Nil if not set.
+ (instancetype)sharedInstance;


/// Instance which has set directoryURL. Method does not create directory.
+ (instancetype)cacheForURL:(NSURL *)directoryURL;

/// Instance which has set directoryURL relative to NSTemporaryDirectory(). Method does not create relative directory.
+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL;



/// Prepare instance to work. Call after init.
- (void)prepare:(NSError **)error;

/// Clean container if exists
- (void)clear;

/// Returns data for key. Nil if key is not set
- (NSData *)dataForKey:(NSString *)key;

/// Store data for passed key.
- (void)storeData:(NSData *)data forKey:(NSString *)key;


@end
