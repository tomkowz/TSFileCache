//
//  TSFileCache+StorageManager.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache+StorageManager.h"

@implementation TSFileCache (StorageManager)

- (NSData *)_readFileAtURL:(NSURL *)fileURL {
    return [NSData dataWithContentsOfURL:fileURL];
}

- (void)_writeData:(NSData *)data atURL:(NSURL *)fileURL {
    [data writeToURL:fileURL atomically:YES];
}

- (void)_clearDirectoryAtURL:(NSURL *)directoryURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:[directoryURL path]];
    
    NSString *fileName = nil;
    while (fileName = [enumerator nextObject]) {
        [fileManager removeItemAtPath:[[directoryURL URLByAppendingPathComponent:fileName] path] error:nil];
    }
}

@end
