//
//  simplegramTests.m
//  simplegramTests
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InstagramAPIHeader.h"
#import "InstagramAPIConstants.h"
#import "InstagramAPI+PrivateMethods.h"

#define kTestRequestTimeout 15

static NSString *const kTestAccessToken = @"InstagramKitBaseUrl";

@interface simplegramTests : XCTestCase

@property (nonatomic, strong) InstagramAPI *api;

@end

@implementation simplegramTests

- (void)setUp {
    [super setUp];
    
    self.api = [InstagramAPI sharedInstance];
}

- (void)tearDown {
    self.api = nil;
    [super tearDown];
}

- (void)testAPIInitialization {
    
    InstagramAPI *testAPI = [InstagramAPI sharedInstance];
    XCTAssertNotNil(testAPI);
    

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testUnauthorizedGetMediaRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed request"];
    Class modelClass = [InstagramMedia class];
    self.api.accessToken = nil;
    
    [self.api getPath:@"media/1032802639895336381_1194245772"
           parameters:nil
        responseModel:modelClass
              success:^(id object) {                
                  XCTAssertNotNil(object);
                  XCTAssertTrue([object isKindOfClass:modelClass]);
                  [expectation fulfill];
              }
              failure:^(NSError *error, NSInteger a) {
                  XCTAssert(NO);
              }];
    
    [self waitForExpectationsWithTimeout:kTestRequestTimeout
     handler:^(NSError *error) {
     XCTAssertNil(error, @"expectation not fulfilled: %@", error);
     }];
     
}


@end
