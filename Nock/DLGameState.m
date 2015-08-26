
#import "DLGameState.h"


@implementation DLGameState{
    NSUserDefaults *_defaults;
    NSDictionary *_settingsDictionary;
    NSInteger _themeIndex;
}

+ (instancetype)sharedGameState{
    
    static DLGameState *sharedGameState;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameState = [[DLGameState alloc] init];
    });
    return sharedGameState;
}


-(id)init{
    if (self = [super init]){
        _defaults = [NSUserDefaults standardUserDefaults];
        _themeIndex = [_defaults integerForKey:@"selectedTheme"];
        _player = [[DLPlayerInfo alloc] init];
        _player.highScore = [_defaults integerForKey:@"highScore"];
        _player.totalScore = [_defaults integerForKey:@"totalScore"];
        _player.totalScore = [_defaults integerForKey:@"totalScore"];
        NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"NockSettings" ofType:@"plist"];
        _settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
        
        NSArray *themes = _settingsDictionary[@"themes"];
        
        _theme = [[DLTheme alloc]initWithDictionary:_settingsDictionary[[themes objectAtIndex:_themeIndex]]];
        
        [self resetGame];
    }
    return self ;
}


-(void) resetGame{
    _isCountdown = YES;
    _isGameOver = NO;
    _totalTime = 10;
    self.playerScore = 0;
}

-(void)setPlayerScore:(NSInteger)playerScore{
    _playerScore = playerScore;
    if (_playerScore > _player.highScore){
        _player.highScore=_playerScore;
    }
}

-(void)setFriendScores:(NSDictionary *)friends{
    self.friendScores = friends;
    _highScores = [[self.friendScores allValues] sortedArrayUsingSelector:@selector(highScoreCompare:)];
    _totalScores = [[self.friendScores allValues] sortedArrayUsingSelector:@selector(totalScoreCompare:)];
}

-(DLPlayerInfo *)nextTarget{
    _currentTarget = _player.highScore;
    for (DLPlayerInfo *info in _highScores){
        if (info.highScore > _playerScore){
            _currentTarget = info.highScore;
            return info;
        }
    }
    //return best score as target
    DLPlayerInfo *best = [[DLPlayerInfo alloc]init];
    best.name = @"Best";
    best.highScore = _player.highScore;
    return best ;
}

-(DLPlayerInfo *)lastTarget{
    DLPlayerInfo *prevPlayer = [[DLPlayerInfo alloc ]init];
    for (DLPlayerInfo *info in _highScores){
        if (info.highScore < _playerScore){
            prevPlayer = info;
        }
    }
    return prevPlayer;
}

-(void)persist{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_player.highScore forKey:@"highScore"];
    [defaults setInteger:_player.totalScore forKey:@"totalScore"];
}

-(void)loadNextTheme{
    
    NSArray *themes = _settingsDictionary[@"themes"];
    
    
    _themeIndex += 1;
    if (_themeIndex >= [themes count]){
        _themeIndex = 0;
    }
    [_defaults setInteger:_themeIndex forKey:@"selectedTheme"];
     _theme = [[DLTheme alloc]initWithDictionary:_settingsDictionary[[themes objectAtIndex:_themeIndex]]];
}

@end
