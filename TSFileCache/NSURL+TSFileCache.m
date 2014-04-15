//
//  NSURL+TSFileCache.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "NSURL+TSFileCache.h"

@implementation NSURL (TSFileCache)

- (NSURL *)_tsfc_appendURL:(NSURL *)url {
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString rangeOfString:@"/"].location == 0) {
        absoluteString = [absoluteString substringFromIndex:1];
    }
    
    return [self URLByAppendingPathComponent:absoluteString];
}

@end
