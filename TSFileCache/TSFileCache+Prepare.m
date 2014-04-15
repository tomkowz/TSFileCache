//
//  TSFileCache+Prepare.m
//  TSFileCache
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "TSFileCache+Prepare.h"
#import "NSError+TSFileCache.h"

static NSString * const TSFileCachePlistFileName = @"content.plist";

@implementation TSFileCache (Prepare)
- (void)prepareWithDirectory:(NSURL *)directoryURL error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    /// Create directory
    [self _prepareDirectoryAtURL:directoryURL error:&localError];
    if (!localError) {
        [self _preparePlistInDirectory:directoryURL error:&localError];
    }
    
    if (localError && error) {
        *error = localError;
    }
}

- (void)_prepareDirectoryAtURL:(NSURL *)directoryURL error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    /// Check if file exists and create directory if necessary
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL fileExists = [fileManager fileExistsAtPath:[directoryURL path] isDirectory:&isDirectory];
    if (fileExists) {
        if (!isDirectory) {
            localError = [NSError _tsfc_errorWithDescription:[NSString stringWithFormat:@"File at path %@ exists and it is not directory. Cannot create directory here.", [directoryURL path]]];
        }
    } else {
        NSError *createDirectoryError = nil;
        [fileManager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&createDirectoryError];
        if (createDirectoryError) {
            localError = [NSError _tsfc_errorWithDescription:createDirectoryError.localizedDescription];
        }
    }
    
    /// Return error if occured
    if (localError && error) {
        *error = localError;
    }
}

- (void)_preparePlistInDirectory:(NSURL *)directoryURL error:(NSError *__autoreleasing *)error {
    /// plist url
    NSURL *fileURL = [directoryURL URLByAppendingPathComponent:TSFileCachePlistFileName];
    
    /// check if file exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:[fileURL path]];
    if (!fileExists) {
        NSDictionary *dictionary = [NSDictionary dictionary];
        BOOL success = [dictionary writeToURL:fileURL atomically:YES];
        /// Raise exception if file has not been created. It's serious error which prevents correct working.
        if (!success && error) {
            *error = [NSError _tsfc_errorWithDescription:[NSString stringWithFormat:@"Serious error. Cannot create internal plist file at path %@.", [fileURL path]]];
        }
    }
}
@end
