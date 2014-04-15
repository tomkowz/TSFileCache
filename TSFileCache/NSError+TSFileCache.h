//
//  NSError+TSFileCache.h
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (TSFileCache)
+ (NSError *)_tsfc_errorWithDescription:(NSString *)description;
@end
