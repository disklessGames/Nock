
#import "DLPlayerInfo.h"

@implementation DLPlayerInfo

@synthesize highScore = _highScore;

-(instancetype)initWithPlayer:(GKPlayer *) player {
    if (self = [super init]){
        self.player = player;
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
