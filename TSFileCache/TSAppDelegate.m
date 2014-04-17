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
    
    /// Test of TSFileCache
    [self firstTest];
    
    /// Test of TSImageCache - It's example of subclassing. TSImageCache has interface prepared to store and read images like icons.
//    [self secondTest];
    return YES;
}

- (void)firstTest {
    TSFileCache *cache = [TSFileCache cacheInTemporaryDirectoryWithRelativeURL:[NSURL URLWithString:@"/FileCache"]];
//    [TSFileCache setSharedInstance:cache]; /// cache should be set as singleton
    [cache prepare:nil];
    
    UIImage *image = [UIImage imageNamed:@"image.png"];
    NSData *data = UIImagePNGRepresentation(image);
    /// save on disk
    for (int i = 0; i < 1000; i++) {
        [cache storeData:data forKey:[NSString stringWithFormat:@"image_%d", i]];
    }
    
    /// read from disk
    for (int i = 0; i < 1000; i++) {
        [cache dataForKey:[NSString stringWithFormat:@"image_%d", i]];
        
    }
    
    /// read from cache
    for (int i = 0; i < 1000; i++) {
        [cache dataForKey:[NSString stringWithFormat:@"image_%d", i]];
    }
    
    /// subscript test
    NSString *str = @"This is a string to save";
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    cache[@"str"] = strData;
    
    NSData *readStringData = cache[@"str"];
    NSData *readStringDataTheSame = [cache dataForKey:@"str"];
    NSLog(@"d1 = %lu, d2 = %lu", (unsigned long)[readStringData length], (unsigned long)[readStringDataTheSame length]);
}

- (void)secondTest {
    TSImageCache *imageCache = [TSImageCache sharedInstance];
    UIImage *image = [UIImage imageNamed:@"image.png"];
    /// store images
    for (int i = 0; i < 1000; i++) {
        [imageCache cacheImage:image forKey:[NSString stringWithFormat:@"image%d", i]];
    }

    /// read from disk
    for (int i = 0; i < 1000; i++) {
        [imageCache imageForKey:[NSString stringWithFormat:@"image%d", i]];
    }
    
    /// read from cache
    for (int i = 0; i < 1000; i += 2) {
        [imageCache cacheImage:image forKey:[NSString stringWithFormat:@"image%d", i]];
    }
}

@end
