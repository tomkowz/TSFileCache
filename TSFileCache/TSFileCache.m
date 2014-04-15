//
//  TSFileCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache.h"
#import "TSFileCache+Prepare.h"
#import "TSFileCache+StorageManager.h"
#import "NSURL+TSFileCache.h"

#pragma mark - TSFileCache
@implementation TSFileCache {
    NSURL *_directoryURL;
    NSCache *_cache;
}


#pragma mark - Initializers
+ (instancetype)cacheForURL:(NSURL *)directoryURL {
    NSParameterAssert(directoryURL && [directoryURL isFileURL]);
    return [[[self class] alloc] _initWithDirectoryURL:directoryURL];
}

+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL {
    NSParameterAssert(relativeURL);
    /// Build url relative to temporary directory
    NSURL *directoryURL = [[self _temporaryDirectoryURL] _tsfc_appendURL:relativeURL];
    return [self cacheForURL:directoryURL];
}


#pragma mark - Initialization
- (instancetype)_initWithDirectoryURL:(NSURL *)directoryURL
{
    self = [super init];
    if (self) {
        _directoryURL = directoryURL;
        _cache = [[NSCache alloc] init];
    }
    return self;
}


#pragma mark - Externals
- (void)prepare:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    [self prepareWithDirectory:_directoryURL error:&localError];
    if (!localError) {
        
    } else if (localError && error) {
        *error = localError;
    }
}

- (void)clear {
    [_cache removeAllObjects];
    [self _clearDirectoryAtURL:_directoryURL];
}

- (NSData *)dataForKey:(NSString *)key {
    NSData *data = nil;
    if (key) {
        data = [_cache objectForKey:key];
        if (!data) {
            data = [self _readFileAtURL:[_directoryURL URLByAppendingPathComponent:key]];
        }
    }
    
    return data;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    if (data && key) {
        [_cache setObject:data forKey:key];
        [self _writeData:data atURL:[_directoryURL URLByAppendingPathComponent:key]];
    }
}


#pragma mark - Helpers
+ (NSURL *)_temporaryDirectoryURL {
    return [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

@end
