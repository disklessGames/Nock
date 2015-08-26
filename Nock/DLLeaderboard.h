//
//  DLLeaderBoard.h
//  Nock
//
//  Created by Jannie Theron on 2014/06/17.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

@import SpriteKit;

@interface DLLeaderboard : SKNode

@property (nonatomic) NSDictionary *scores;

-(id)initWithSize:(CGSize)leaderboardSize atPosition:(CGPoint)centerPosition;

@end