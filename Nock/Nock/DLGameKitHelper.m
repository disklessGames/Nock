
#import "DLGameKitHelper.h"
#import "Nock-Swift.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LeaderboardIPhone = @"iPhoneMax";
NSString *const LeaderboardIPad = @"iPadMax";
NSString *const LeaderboardTotal = @"playerTotal";
NSString *const DLShowAds = @"disklessEnableAds";
NSString *const DLHideAds = @"disklessDisableAds";


@implementation DLGameKitHelper
@synthesize gameCenterEnabled = _gameCenterEnabled;
@synthesize totalScore = _totalScore;
@synthesize highScore  = _highScore;
@synthesize lastScore = _lastScore;
@synthesize playersHighScores = _playersHighScores;
@synthesize playersTotalScores = _playersTotalScores;
@synthesize authenticationViewController = _authenticationViewController;
@synthesize localPlayer = _localPlayer;

+ (instancetype)sharedGameKitHelper
{
    static DLGameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[DLGameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _gameCenterEnabled = NO;
        
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    _localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    _localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [[DLGameKitHelper sharedGameKitHelper] setLastError:error];
        
        if(viewController != nil) {
            //4
            [[DLGameKitHelper sharedGameKitHelper] setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            
            [DLGameKitHelper sharedGameKitHelper ].gameCenterEnabled = YES;
            [DLGameState sharedGameState].player.id = [GKLocalPlayer localPlayer].playerID;

            [[DLGameKitHelper sharedGameKitHelper]refreshGameStateScores];
        } else {
            //6
            [DLGameKitHelper sharedGameKitHelper].gameCenterEnabled = NO;
        }
    };
}

- (void)setAuthenticationViewController:(ViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}


-(void)refreshGameStateScores{
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier = LeaderboardTotal;
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (scores) {
            GKScore *localPlayerScore = leaderboardRequest.localPlayerScore;
            
            [DLGameState sharedGameState].player.totalScore =  [NSNumber numberWithLongLong:localPlayerScore.value].integerValue;
            NSMutableDictionary *friends = [NSMutableDictionary dictionaryWithCapacity:[scores count]];
            
            [scores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                GKScore *s = (GKScore *)obj;
                DLPlayerInfo *newFriend = [[DLPlayerInfo alloc ]init];
                newFriend.id = s.player;
                newFriend.totalScore = (NSInteger)s.value;
                [friends setValue:newFriend forKey:newFriend.id];
            }];
            [DLGameState sharedGameState].friendScores = friends;
            [GKPlayer loadPlayersForIdentifiers:[_playersTotalScores allKeys] withCompletionHandler:^(NSArray *players, NSError *error) {
                [players enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    GKPlayer *p = (GKPlayer *)obj;
                    DLPlayerInfo *currentPlayer = [DLGameState sharedGameState].friendScores[p.playerID];
                    currentPlayer.name = p.displayName;
                    [p loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
                        if (photo) {
                            currentPlayer.photo=photo;
                        }
                    }];//photo loaded
                }];//player set up
            }];
        }
    }];
   
    
    GKLeaderboard *leaderboardRequest2 = [[GKLeaderboard alloc] init];
    if (IPAD){
        leaderboardRequest2.identifier = LeaderboardIPad;
    }else{
        leaderboardRequest2.identifier = LeaderboardIPhone;
    }
    leaderboardRequest2.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    leaderboardRequest2.timeScope = GKLeaderboardTimeScopeAllTime;
    [leaderboardRequest2 loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            //NSLog(@"%@", error);
        } else if (scores) {
            GKScore *localPlayerScore = leaderboardRequest2.localPlayerScore;
            //NSLog(@"Local player's score from Leaderboard %@: %lld", LeaderboardIPad, localPlayerScore.value);
            [DLGameKitHelper sharedGameKitHelper].highScore = [NSNumber numberWithLongLong:localPlayerScore.value].integerValue;
            [scores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                GKScore *s = (GKScore *)obj;
                [[DLGameState sharedGameState].friendScores[s.playerID] setHighScore:(NSInteger)s.value];
            }];
        }
    }];
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        //NSLog(@"GameKitHelper ERROR: %@",[[_lastError userInfo] description]);
    }
}

- (void) updateAndShowGameCenter
{
    [[DLGameKitHelper sharedGameKitHelper] persistScoreswithCompletionHandler:^(id ibject) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            [_authenticationViewController presentViewController: gameCenterController animated: YES completion:nil];
        }
    }];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
      [_authenticationViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) persistScoreswithCompletionHandler:(void (^)(id))block{
    
    DLGameState *gameState = [DLGameState sharedGameState];
    [gameState persist];
    
    GKScore *score = [GKScore alloc];
    
    if (IPAD){
        score = [score initWithLeaderboardIdentifier:LeaderboardIPad];
        
    
    }else{
        score = [score initWithLeaderboardIdentifier:LeaderboardIPhone];
        
    }
    score.value = gameState.player.highScore;
    GKScore *scoretotal = [[GKScore alloc] initWithLeaderboardIdentifier:LeaderboardTotal];
    scoretotal.value =  gameState.player.totalScore;
    
    [GKScore reportScores:@[score,scoretotal] withCompletionHandler:block];
}

@end
