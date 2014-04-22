//
//  TSFileCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//  http://github.com/tomkowz/TSFileCache
//

#import <Foundation/Foundation.h>

/** 
 If you want to prevent your subclass to use one of methods below apply this macro.
 + (void)setSharedInstance:(TSFileCache *)instance __TSFileCacheUnavailable__;
 */
#ifndef __TSFileCacheUnavailable__
    #define __TSFileCacheUnavailable__ __attribute__((unavailable("Method is not available in this subclass.")))
#endif

@interface TSFileCache : NSObject

@property (nonatomic, readonly) NSURL *directoryURL;

/// Set shared instance.
+ (void)setSharedInstance:(TSFileCache *)instance;

/// Get shared instance. Nil if not set.
+ (instancetype)sharedInstance;



/// Instance which has set directoryURL. Method does not create directory.
+ (instancetype)cacheForURL:(NSURL *)directoryURL;

/// Instance which has set directoryURL relative to NSTemporaryDirectory(). Method does not create relative directory.
+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL;



/// Prepare instance to work. Call after init.
- (BOOL)prepare:(NSError **)error;

/// Clear container if exists - directory will still exists
- (void)clear;


/// Returns data for key. Nil if key is not set
- (NSData *)dataForKey:(NSString *)key;

/// Store data for passed key.
- (void)storeData:(NSData *)data forKey:(NSString *)key;

/// Store data for undefined key. Returns key. Key is unique.
- (NSString *)storeDataForUndefinedKey:(NSData *)data;

/// Removes data for specified key
- (void)removeDataForKey:(NSString *)key;

/// Check if data exists for key.
- (BOOL)existsDataForKey:(NSString *)key;

/// Returns all set keys.
- (NSArray *)allKeys;

/// If file exists attributes will be returned. Otherwise empty dictionary.
- (NSDictionary *)attributesOfFileForKey:(NSString *)key error:(NSError **)error;

@end


/// object[@"key"] = ...;, NSData *value = object[@"key"];
@interface TSFileCache (Subscript)
- (NSData *)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(NSData *)data forKeyedSubscript:(NSString *)key;
@end

