//
//  TSAppDelegate.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSAppDelegate.h"
#import "TSFileCache.h"
#import "TSImageCache.h"

@implementation TSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /// Test TSFileCache
//    [self testTSFileCacheExample];
    /// Test image cache
    [self testTSImageCacheExample];
    return YES;
}

- (void)testTSFileCacheExample {
    TSFileCache *cache = [TSFileCache cacheInTemporaryDirectoryWithRelativeURL:[NSURL URLWithString:@"/FileCache"]];
    [cache prepare:nil];
    
    UIImage *image = [UIImage imageNamed:@"image.png"];
    NSData *data = UIImagePNGRepresentation(image);
    for (int i = 0; i < 1000; i++) {
        [cache storeData:data forKey:[NSString stringWithFormat:@"image_%d", i]];
    }
    
    for (int i = 0; i < 1000; i++) {
        NSData *data = [cache dataForKey:[NSString stringWithFormat:@"image_%d", i]];
    }
    
    for (int i = 0; i < 1000; i++) {
        NSData *data = [cache dataForKey:[NSString stringWithFormat:@"image_%d", i]];
    }
}

- (void)testTSImageCacheExample {
    [self testCacheImage];
    [self testReadImageFromCache];
    [self testReadImageFromCache];
    [self testCacheImage2];
    [self testReadImageFromCache];
}

- (void)testCacheImage {
    TSImageCache *imageCache = [TSImageCache sharedInstance];
    UIImage *image = [UIImage imageNamed:@"image.png"];
    for (int i = 0; i < 1000; i++) {
        [imageCache cacheImage:image forKey:[NSString stringWithFormat:@"image%d", i]];
    }
}

- (void)testReadImageFromCache {
    TSImageCache *imageCache = [TSImageCache sharedInstance];
    for (int i = 0; i < 1000; i++) {
        UIImage *image = [imageCache imageForKey:[NSString stringWithFormat:@"image%d", i]];
        /// do something with image
    }
}

- (void)testCacheImage2 {
    TSImageCache *imageCache = [TSImageCache sharedInstance];
    UIImage *image = [UIImage imageNamed:@"image.png"];
    for (int i = 0; i < 1000; i += 2) {
        [imageCache cacheImage:image forKey:[NSString stringWithFormat:@"image%d", i]];
    }
}

@end
