
#import <Foundation/Foundation.h>
#import "DLLeaderBoard.h"
#import "Nock-Swift.h"

@implementation DLLeaderboard{
    GameState *_gameState;
}

-(instancetype)initWithSize:(CGSize)leaderboardSize atPosition:(CGPoint)centerPosition{
    if (self = [super init]){
        _gameState = [GameState sharedGameState];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:leaderboardSize];
        background.alpha = 0.6;
        background.zPosition = 100;
        background.position = centerPosition;
        [self addChild:background];
        int i=0;
        for (PlayerInfo *score in _scores[@"Total Nocks"]){
            SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:_gameState.currentTheme.font];
            scoreLabel.text = [NSString stringWithFormat:@"%d. %@  %ld",i++,
                               score.name,(long)score.highScore];
        }
    }
    return self;
}

@end