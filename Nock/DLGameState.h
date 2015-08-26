
#import <Foundation/Foundation.h>
#import "DLPlayerInfo.h"
#import "DLTheme.h"

@interface DLGameState : NSObject

@property (nonatomic) float totalTime;
@property (nonatomic) DLPlayerInfo *player;
@property (nonatomic) NSInteger playerScore;
@property (nonatomic) BOOL isCountdown;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) NSDictionary *friendScores;
@property (nonatomic) NSInteger currentTarget;
@property (nonatomic, readonly) NSArray *highScores;
@property (nonatomic, readonly) NSArray *totalScores;
@property (nonatomic) DLTheme *theme;

+ (instancetype)sharedGameState;

- (void)resetGame;
-(DLPlayerInfo *)nextTarget;
-(DLPlayerInfo *)lastTarget;
-(void)persist;
-(void)loadNextTheme;

@end
