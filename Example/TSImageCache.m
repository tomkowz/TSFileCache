//
//  ExampleImageCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSImageCache.h"

@implementation TSImageCache

static TSImageCache *_sharedInstance = nil;
+ (instancetype)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [super cacheInTemporaryDirectoryWithRelativeURL:[NSURL fileURLWithPath:@"/Cache/Images"]];
        /// Prepare directory
        [_sharedInstance prepare:nil];
    }
    return _sharedInstance;
}

- (UIImage *)imageForKey:(NSString *)key {
    NSData *data = [super dataForKey:key];
    return [UIImage imageWithData:data];
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    NSData *data = UIImagePNGRepresentation(image);
    [super storeData:data forKey:key];
}

- (void)clear {
    [super clear];
}

@end
