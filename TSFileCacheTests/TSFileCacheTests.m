//
//  TSFileCacheTests.m
//  TSFileCacheTests
//
//  Created by Tomasz Szulc on 15/04/14.
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

#pragma mark - directoryURL
- (void)testThatDirectoryURLPropertyIsNotNil {
    XCTAssertNotNil(_fileCache.directoryURL, @"");
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
    BOOL success = [_fileCache prepare:&prepareError];
    XCTAssertNil(prepareError, @"");
    XCTAssertTrue(success, @"");
}

- (void)testThatPrepareShouldEndWithErrorBecauseOfExistingFile {
    NSURL *testURL = [self testURL];
    /// save file
    NSString *testString = @"This is a string";
    NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:testURL atomically:YES];
    
    NSError *prepareError = nil;
    BOOL success = [_fileCache prepare:&prepareError];
    XCTAssertNotNil(prepareError, @"");
    XCTAssertFalse(success, @"");
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


#pragma mark - storeDataForAnonymousKey:
- (void)testThatDataIsStoredCorrectlyAndKeyIsReturned {
    NSData *data = [@"This is a string to save" dataUsingEncoding:NSUTF8StringEncoding];
    [_fileCache prepare:nil];
    NSString *key = [_fileCache storeDataForUndefinedKey:data];
    XCTAssertNotNil(key, @"");
    XCTAssertNotNil(_fileCache[key], @"");
}


#pragma mark - Subscript tests
- (void)testThatDataCanBeSetViaSubscript {
    [_fileCache prepare:nil];
    _fileCache[@"data"] = [NSData data];
    XCTAssertNotNil(_fileCache[@"data"], @"");
}


#pragma mark - existsObjectForKey:
- (void)testThatObjectExistsForKey {
    [_fileCache prepare:nil];
    _fileCache[@"a"] = [NSData data];
    XCTAssertTrue(_fileCache[@"a"], @"");
    XCTAssertFalse(_fileCache[@"b"], @"");
}


#pragma mark - removeDataForKey:
- (void)testThatDataShouldBeRemoved {
    [_fileCache prepare:nil];
    _fileCache[@"a"] = [NSData data];
    [_fileCache removeDataForKey:@"a"];
    XCTAssertFalse(_fileCache[@"a"], @"");
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


#pragma mark - allKeys
- (void)testThatCorrectKeysShouldBeReturned {
    [_fileCache prepare:nil];
    NSData *data = [@"this is a string" dataUsingEncoding:NSUTF8StringEncoding];

    NSUInteger numberOfItems = 10;
    for (int i = 0; i < numberOfItems; i++) {
        [_fileCache storeDataForUndefinedKey:data];
    }
    
    XCTAssertEqual([_fileCache allKeys].count, numberOfItems, @"");
}

- (void)testThatEmptyArrayShouldBeReturnedIfInContainerIsZeroElements {
    [_fileCache prepare:nil];
    XCTAssertNotNil([_fileCache allKeys], @"");
}


#pragma mark - attributesOfFileForKey:
- (void)testThatAttributesShouldBeReturned {
    [_fileCache prepare:nil];
    NSData *data = [@"this is a string" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *key = [_fileCache storeDataForUndefinedKey:data];

    NSDictionary *attributes = [_fileCache attributesOfFileForKey:key error:nil];
    XCTAssertTrue([attributes allKeys].count > 0, @"");
}

@end
