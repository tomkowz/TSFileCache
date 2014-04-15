//
//  NSError+TSFileCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "NSError+TSFileCache.h"

static NSString * const TSFileCacheErrorDomain = @"TSFileCacheErrorDomain";

@implementation NSError (TSFileCache)

+ (NSError *)_tsfc_errorWithDescription:(NSString *)description {
    NSDictionary *info = @{NSLocalizedDescriptionKey : description};
    return [NSError errorWithDomain:TSFileCacheErrorDomain code:-1 userInfo:info];
}

@end