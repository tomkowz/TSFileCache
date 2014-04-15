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

@implementation TSFileCacheTests {
    TSFileCache *_fileCache;
}

- (void)setUp
{
    [super setUp];
    [TSFileCache setSharedInstance:nil];
    _fileCache = [TSFileCache cacheForURL:[self testURL]];
    [[NSFileManager defaultManager] removeItemAtURL:[self testURL] error:nil];
}

- (void)tearDown
{
    _fileCache = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[self testURL] error:nil];
    [TSFileCache setSharedInstance:nil];
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


#pragma mark - setSharedInstance:
- (void)testThatSharedInstanceShouldBeSet {
    [TSFileCache setSharedInstance:_fileCache];
    XCTAssertNotNil([TSFileCache sharedInstance], @"");
}

- (void)testThatSharedInstanceShouldBeNilIfNotSet {
    XCTAssertNil([TSFileCache sharedInstance], @"");
}


#pragma mark - prepare:
- (void)testThatPrepareShouldEndWithoutError {
    NSError *prepareError = nil;
    [_fileCache prepare:&prepareError];
    XCTAssertNil(prepareError, @"");
}

- (void)testThatPrepareShouldEndWithErrorBecauseOfExistingFile {
    NSURL *testURL = [self testURL];
    /// save file
    NSString *testString = @"This is a string";
    NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:testURL atomically:YES];
    
    NSError *prepareError = nil;
    [_fileCache prepare:&prepareError];
    XCTAssertNotNil(prepareError, @"");
}


#pragma mark - dataForKey:
- (void)testThatDataShouldBeNilForNotExistingKey {
    [_fileCache prepare:nil];
    XCTAssertNil([_fileCache dataForKey:@"Key"], @"");
}


#pragma mark - storeData:forKey:
- (void)testThatDataShouldBeStored {
    [_fileCache prepare:nil];
    
    /// store
    NSString *string = @"This is string to store";
    NSData *dataToStore = [string dataUsingEncoding:NSUTF8StringEncoding];
    [_fileCache storeData:dataToStore forKey:@"Key"];
    
    TSFileCache *secondCache = [TSFileCache cacheForURL:[self testURL]];
    [secondCache prepare:nil];
    XCTAssertNotNil([secondCache dataForKey:@"Key"], @"");
}


#pragma mark - clean
- (void)testThatDataCacheShouldBeEmpty {
    NSString *string = @"This is a string which will be stored and removed later";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [_fileCache prepare:nil];
    [_fileCache storeData:data forKey:@"key1"];
    [_fileCache storeData:data forKey:@"key2"];
    [_fileCache storeData:data forKey:@"key3"];
    
    [_fileCache clear];
    
    XCTAssertNil([_fileCache dataForKey:@"key1"], @"");
    XCTAssertNil([_fileCache dataForKey:@"key2"], @"");
    XCTAssertNil([_fileCache dataForKey:@"key3"], @"");
}

- (NSURL *)testURL {
    return [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:mainTestDirectory];
}

@end
