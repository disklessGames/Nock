//
//  NockTests.m
//  NockTests
//
//  Created by Jannie Theron on 2014/05/12.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLMenuScene.h"
#import "DLGameScene.h"

@interface NockTests : XCTestCase

@property DLMenuScene *menu;
@property DLGameScene *gameScene;
@end

@implementation NockTests

- (void)setUp
{
    [super setUp];
    self.menu = [[DLMenuScene alloc ] init];
    self.gameScene = [[DLGameScene alloc] init];
}

- (void)tearDown
{
    self.menu = nil;
    self.gameScene = nil;
    [super tearDown];
}

- (void)testCreateMenu
{
    XCTAssertNotNil(self.menu);
}

@end
