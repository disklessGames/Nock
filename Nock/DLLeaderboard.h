
@import SpriteKit;

@interface DLLeaderboard : SKNode

@property (nonatomic) NSDictionary *scores;

-(id)initWithSize:(CGSize)leaderboardSize atPosition:(CGPoint)centerPosition;

@end