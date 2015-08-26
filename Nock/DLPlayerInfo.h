
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GKPlayer;

@interface DLPlayerInfo : NSObject

@property (nonatomic) GKPlayer *player;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) UIImage *photo;

-(instancetype)initWithPlayer:(GKPlayer *)player;
- (NSComparisonResult)highScoreCompare:(DLPlayerInfo *)aPlayer;
- (NSComparisonResult)totalScoreCompare:(DLPlayerInfo *)aPlayer;

@end
