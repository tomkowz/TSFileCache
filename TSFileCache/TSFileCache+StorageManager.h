//
//  TSFileCache+StorageManager.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache.h"

@interface TSFileCache (StorageManager)
- (NSData *)_readFileAtURL:(NSURL *)fileURL;
- (void)_writeData:(NSData *)data atURL:(NSURL *)fileURL;
- (void)_clearDirectoryAtURL:(NSURL *)storageURL;
@end
