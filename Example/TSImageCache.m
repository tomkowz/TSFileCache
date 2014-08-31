//
//  ExampleImageCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc on 15/04/14.
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
    UIImage *image = [self.cache objectForKey:key];
    if (key && !image) {
        if ([self existsDataForKey:key]) {
            NSData *data = [super dataForKey:key];
            if (data) {
                image = [UIImage imageWithData:data];
                [self.cache setObject:image forKey:key];
            }
        }
    }
    return image;
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    [self.cache setObject:image forKey:key];
    NSData *data = UIImagePNGRepresentation(image);
    [super writeDataOnDisk:data forKey:key];
}

- (NSString *)cacheImageForUndefinedKey:(UIImage *)image store:(BOOL)store {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *key = [super storeDataForUndefinedKey:data];
    if (store) {
        [self.cache setObject:image forKey:key];
    }
    return key;
}

- (void)clear {
    [super clear];
}

@end

@implementation TSImageCache (Subscript)

- (void)setObject:(UIImage *)image forKeyedSubscript:(NSString *)key {
    [self cacheImage:image forKey:key];
}

- (UIImage *)objectForKeyedSubscript:(NSString *)key {
    return [self imageForKey:key];
}

@end