//
//  TSFileCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache.h"

#define URLTo(url) [_directoryURL URLByAppendingPathComponent:url]

@interface NSURL (TSFileCache)
- (NSURL *)_tsfc_appendURL:(NSURL *)url;
@end

static NSString * const TSFileCacheErrorDomain = @"TSFileCacheErrorDomain";
@interface NSError (TSFileCache)
+ (NSError *)_tsfc_errorWithDescription:(NSString *)description;
@end


@interface TSFileCache (Prepare)
- (BOOL)_prepareWithDirectoryAtURL:(NSURL *)directoryURL error:(NSError **)error;
@end

@interface TSFileCache (StorageManager)
- (BOOL)_existsFileAtURL:(NSURL *)fileURL;
- (NSData *)_readFileAtURL:(NSURL *)fileURL;
- (void)_writeData:(NSData *)data atURL:(NSURL *)fileURL;
- (void)_removeDataAtURL:(NSURL *)fileURL;
- (void)_clearDirectoryAtURL:(NSURL *)storageURL;
- (NSArray *)_allFileNamesAtURL:(NSURL *)directoryURL;
- (NSDictionary *)_attributesOfFileAtURL:(NSURL *)fileURL error:(NSError **)error;
@end


@implementation TSFileCache {
    NSCache *_cache;
}

static TSFileCache *_sharedInstance = nil;
+ (void)setSharedInstance:(TSFileCache *)instance {
    _sharedInstance = instance;
}

+ (instancetype)sharedInstance {
    return _sharedInstance;
}

#pragma mark - Initializers
+ (instancetype)cacheForURL:(NSURL *)directoryURL {
    NSParameterAssert(directoryURL && [directoryURL isFileURL]);
    return [[self alloc] _initWithDirectoryURL:directoryURL];
}

+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL {
    NSParameterAssert(relativeURL);
    /// Build url relative to temporary directory
    NSURL *directoryURL = [[self _temporaryDirectoryURL] _tsfc_appendURL:relativeURL];
    return [self cacheForURL:directoryURL];
}


#pragma mark - Initialization
- (instancetype)_initWithDirectoryURL:(NSURL *)directoryURL {
    self = [super init];
    if (self) {
        _directoryURL = directoryURL;
        _cache = [[NSCache alloc] init];
    }
    return self;
}


#pragma mark - Externals
- (BOOL)prepare:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    BOOL success = [self _prepareWithDirectoryAtURL:_directoryURL error:&localError];
    /// log error if occured
    if (localError && error) {
        *error = localError;
    }
    return success;
}

- (void)clear {
    [_cache removeAllObjects];
    [self _clearDirectoryAtURL:_directoryURL];
}

- (NSData *)dataForKey:(NSString *)key {
    NSData *data = nil;
    if (key) {
        data = [_cache objectForKey:key];
        if (!data && [self existsDataForKey:key]) {
            data = [self _readFileAtURL:URLTo(key)];
            if (data)
                [_cache setObject:data forKey:key];
        }
    }
    return data;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    if (data && key) {
        [self _writeData:data atURL:[_directoryURL URLByAppendingPathComponent:key]];
    }
}

- (NSString *)storeDataForUndefinedKey:(NSData *)data {
    NSString *key = nil;
    if (data) {
        do {
            key = [self _generateKey];
        } while (!key || (key && [self existsDataForKey:key]));
        
        [self storeData:data forKey:key];
    }
    return key;
}

- (void)removeDataForKey:(NSString *)key {
    [_cache removeObjectForKey:key];
    [self _removeDataAtURL:URLTo(key)];
}

- (BOOL)existsDataForKey:(NSString *)key {
    BOOL exists = NO;
    if (key) {
        exists = [self _existsFileAtURL:URLTo(key)];
    }
    return exists;
}

- (NSArray *)allKeys {
    return [self _allFileNamesAtURL:_directoryURL];
}

- (NSDictionary *)attributesOfFileForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    NSDictionary *attributes = [NSDictionary dictionary];
    if (key) {
        NSDictionary *tmpAttributes = [self _attributesOfFileAtURL:URLTo(key) error:&localError];
        if (tmpAttributes) {
            attributes = tmpAttributes;
        }
        
        if (localError && error) {
            *error = localError;
        }
    }
    
    return attributes;
}

+ (NSURL *)_temporaryDirectoryURL {
    return [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

- (NSString *)_generateKey {
    return [[NSUUID UUID] UUIDString];
}

@end

@implementation TSFileCache (Subscript)

- (NSData *)objectForKeyedSubscript:(NSString *)key {
    return [self dataForKey:key];
}

- (void)setObject:(NSData *)data forKeyedSubscript:(NSString *)key {
    [self storeData:data forKey:key];
}

@end

@implementation TSFileCache (Prepare)
- (BOOL)_prepareWithDirectoryAtURL:(NSURL *)directoryURL error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    /// Check if file exists and create directory if necessary
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL fileExists = [fileManager fileExistsAtPath:[directoryURL path] isDirectory:&isDirectory];
    if (fileExists) {
        if (!isDirectory) {
            localError = [NSError _tsfc_errorWithDescription:[NSString stringWithFormat:@"File at path %@ exists and it is not directory. Cannot create directory here.", [directoryURL path]]];
        }
    } else {
        NSError *createDirectoryError = nil;
        [fileManager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&createDirectoryError];
        if (createDirectoryError) {
            localError = [NSError _tsfc_errorWithDescription:createDirectoryError.localizedDescription];
        }
    }
    
    /// Return error if occured
    if (localError && error) {
        *error = localError;
    }
    
    return (localError == nil);
}

@end

@implementation TSFileCache (StorageManager)

- (BOOL)_existsFileAtURL:(NSURL *)fileURL {
    return [[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]];
}

- (NSData *)_readFileAtURL:(NSURL *)fileURL {
    return [[NSData alloc] initWithContentsOfURL:fileURL options:NSDataReadingUncached error:nil];
}

- (void)_writeData:(NSData *)data atURL:(NSURL *)fileURL {
    [data writeToURL:fileURL atomically:YES];
}

- (void)_removeDataAtURL:(NSURL *)fileURL {
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
}

- (void)_clearDirectoryAtURL:(NSURL *)directoryURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [self _allFileNamesAtURL:directoryURL];
    for (NSString *fileName in fileNames) {
        [fileManager removeItemAtPath:[[directoryURL URLByAppendingPathComponent:fileName] path] error:nil];
    }
}

- (NSArray *)_allFileNamesAtURL:(NSURL *)directoryURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:[directoryURL path]];
    
    return [[enumerator allObjects] copy];
}

- (NSDictionary *)_attributesOfFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:&localError];
    if (localError && error) {
        *error = localError;
    }
    
    return attributes;
}

@end


@implementation NSURL (TSFileCache)

- (NSURL *)_tsfc_appendURL:(NSURL *)url {
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString rangeOfString:@"/"].location == 0) {
        absoluteString = [absoluteString substringFromIndex:1];
    }
    
    return [self URLByAppendingPathComponent:absoluteString];
}

@end

@implementation NSError (TSFileCache)

+ (NSError *)_tsfc_errorWithDescription:(NSString *)description {
    NSDictionary *info = @{NSLocalizedDescriptionKey : description};
    return [NSError errorWithDomain:TSFileCacheErrorDomain code:-1 userInfo:info];
}

@end
