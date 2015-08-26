//
//  DLLeaderBoard.m
//  Nock
//
//  Created by Jannie Theron on 2014/06/17.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLLeaderBoard.h"
#import "DLGameState.h"

@implementation DLLeaderboard{
    DLGameState *_gameState;
}

@synthesize scores = _scores;

-(instancetype)initWithSize:(CGSize)leaderboardSize atPosition:(CGPoint)centerPosition{
    if (self = [super init]){
        _gameState = [DLGameState sharedGameState];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:leaderboardSize];
        background.alpha = 0.6;
        background.zPosition = 100;
        background.position = centerPosition;
        [self addChild:background];
        int i=0;
        for (DLPlayerInfo *score in _scores[@"Total Nocks"]){
            SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
            scoreLabel.text = [NSString stringWithFormat:@"%d. %@  %ld",i++,
                               score.name,(long)score.highScore];
        }
    }
    return self;
}

@end