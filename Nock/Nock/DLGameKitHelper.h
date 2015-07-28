//
//  DLGameKitHelper.h
//  Nock
//
//  Created by Jannie Theron on 2014/05/19.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLMenuScene.h"
#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "DLPlayerInfo.h"
#import "DLGameState.h"


#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
extern NSString *const PresentAuthenticationViewController;
extern NSString *const LeaderboardIPhone;
extern NSString *const LeaderboardIPad;
extern NSString *const LeaderboardTotal;
extern NSString *const DLShowAds;
extern NSString *const DLHideAds;

@interface DLGameKitHelper : NSObject <GKGameCenterControllerDelegate>

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger lastScore;
@property (nonatomic) NSMutableDictionary *playersHighScores;
@property (nonatomic) NSMutableDictionary *playersTotalScores;
@property (nonatomic) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;
@property (nonatomic) GKLocalPlayer *localPlayer;


+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)refreshGameStateScores;
- (void) updateAndShowGameCenter;
- (void) persistScoreswithCompletionHandler:(void (^)(id object))block;

@end
