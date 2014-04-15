//
//  TSFileCacheTests.m
//  TSFileCacheTests
//
//  Created by Tomasz Szulc Prywatny on 15/04/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSFileCache.h"

@interface TSFileCacheTests : XCTestCase

@end

static NSString * const mainTestDirectory = @"aslkdjfsalkdjfskfdl-sdfsasdfsalfkj9889990-sdfsdfsd";

@implementation TSFileCacheTests

- (void)setUp
{
    [super setUp];
    [[NSFileManager defaultManager] removeItemAtURL:[self testURL] error:nil];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtURL:[self testURL] error:nil];
    [super tearDown];
}


#pragma mark - cacheForURL:
- (void)testThatInstanceShouldExistsForFileURL {
    XCTAssertNotNil([TSFileCache cacheForURL:[NSURL fileURLWithPath:NSTemporaryDirectory()]], @"");
}

- (void)testThatMethodShouldThrowExceptionForURLWhichIsNotFileURL {
    XCTAssertThrows([TSFileCache cacheForURL:[NSURL URLWithString:@"http://www.example.com"]], @"");
}

- (void)testThatMethodShouldThrowExceptionForNilURL {
    XCTAssertThrows([TSFileCache cacheForURL:nil], @"");
}


#pragma mark - cacheInTemporaryDirectoryWithRelativeURL
- (void)testThatInstanceShouldExistsForRelativeURL {
    XCTAssertNotNil([TSFileCache cacheInTemporaryDirectoryWithRelativeURL:[NSURL URLWithString:@"Cache/Images"]], @"");
}

- (void)testThatInstanceShouldThrowExceptionForNilRelativeURL {
    XCTAssertThrows([TSFileCache cacheInTemporaryDirectoryWithRelativeURL:nil], @"");
}


#pragma mark - prepare:
- (void)testThatPrepareShouldEndWithoutError {
    NSURL *testURL = [self testURL];
    TSFileCache *cache = [TSFileCache cacheForURL:testURL];
    NSError *prepareError = nil;
    [cache prepare:&prepareError];
    XCTAssertNil(prepareError, @"");
}

- (void)testThatPrepareShouldEndWithErrorBecauseOfExistingFile {
    NSURL *testURL = [self testURL];
    /// save file
    NSString *testString = @"This is a string";
    NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:testURL atomically:YES];
    
    TSFileCache *cache = [TSFileCache cacheForURL:testURL];
    NSError *prepareError = nil;
    [cache prepare:&prepareError];
    XCTAssertNotNil(prepareError, @"");
}

- (NSURL *)testURL {
    return [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:mainTestDirectory];
}

@end
