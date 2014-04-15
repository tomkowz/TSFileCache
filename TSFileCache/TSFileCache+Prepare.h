//
//  TSFileCache+Prepare.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache.h"

@interface TSFileCache (Prepare)
- (void)prepareWithDirectory:(NSURL *)directoryURL error:(NSError *__autoreleasing *)error;
@end
