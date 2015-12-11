//  DLGameState.h
//  Nock
//
//  Created by Jannie Theron on 2014/05/27.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DLPlayerInfo : NSObject

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) UIImage *photo;

-(instancetype)initWithPlayerID:(NSString *)playerId;
- (NSComparisonResult)highScoreCompare:(DLPlayerInfo *)aPlayer;
- (NSComparisonResult)totalScoreCompare:(DLPlayerInfo *)aPlayer;

@end
