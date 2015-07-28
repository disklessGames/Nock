
#import <Foundation/Foundation.h>

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
