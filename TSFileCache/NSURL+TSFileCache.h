//
//  NSURL+TSFileCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (TSFileCache)
- (NSURL *)_tsfc_appendURL:(NSURL *)url;
@end
