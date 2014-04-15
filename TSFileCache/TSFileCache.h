//
//  TSFileCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSFileCache : NSObject

/**
 Method returns instance which has set directoryURL. Method does not create directory.
*/
+ (instancetype)cacheForURL:(NSURL *)directoryURL;

/**
 Method returns instance which has set directoryURL relative to NSTemporaryDirectory(). Method does not create relative directory.
*/
+ (instancetype)cacheInTemporaryDirectoryWithRelativeURL:(NSURL *)relativeURL;

/**
 Method prepare instance to work.
 */
- (void)prepare:(NSError **)error;

@end
