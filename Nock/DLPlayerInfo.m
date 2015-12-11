//
//  DLGameState.m
//  Nock
//
//  Created by Jannie Theron on 2014/05/27.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import "DLPlayerInfo.h"

@implementation DLPlayerInfo

@synthesize highScore = _highScore;

-(instancetype)initWithPlayerID:(NSString *)playerId{
    if (self = [super init]){
        _id = playerId;
    }
    return self;
}


- (NSComparisonResult)highScoreCompare:(DLPlayerInfo *)aPlayer{
    if (_highScore > aPlayer.highScore){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}

- (NSComparisonResult)totalScoreCompare:(DLPlayerInfo *)aPlayer{
    if (_totalScore > aPlayer.totalScore){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}

@end
