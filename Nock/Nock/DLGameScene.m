
#import "DLGameScene.h"
#import "DLMenuScene.h"
#import "DLPuck.h"
#import "DLGameKitHelper.h"
#import "DLGameState.h"

enum {
    CollisionPlayer =  0x1 << 0,
    CollisionBall = 0x1 << 1,
    CollisionWall = 0x1 << 2
};

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface DLGameScene()

@property NSDictionary *settingsDictionary;
@property SKNode *field;
@property SKNode *hud;
@property DLPuck *ball;
@property DLPuck *player;

@property CGPoint startLocation;
@property NSInteger playerPullForceScale;
@property NSInteger playerFlickForceScale;

@property CFTimeInterval startTime;
@property SKLabelNode *timeLabel;
@property SKLabelNode *scoreLabel;
@property SKLabelNode *targetScoreLabel;
@property SKLabelNode *scoreLabelName;
@property SKLabelNode *targetScoreLabelName;

@property SKNode *info;
@property DLGameState *gameState;
@property DLGameKitHelper *gameKitHelper;
@property BOOL poweredUp;
@property SKAction *scorePopAction;
@property float timeLeft;
@property NSInteger timeBonus;
@property SKEmitterNode *timeBonusEmitter;

@end
@implementation DLGameScene{
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _gameState = [DLGameState sharedGameState];
        _gameKitHelper = [DLGameKitHelper sharedGameKitHelper];
        _poweredUp = NO;
        _timeBonus = 0;
        
        [self loadSettings];
        [self setupPhysics];
        [self setUpField];
        [self setUpPlayer];
        [self setUpOpponents];
        [self setupHUD];
        
        SKAction *zoom = [SKAction scaleTo:1.2 duration:0.2];
        _scorePopAction = [SKAction sequence:@[zoom,[zoom reversedAction]]];
        
        [self orderZPositions];
        
    }
    return self;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_gameState.isGameOver){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"Done"]) {
            DLMenuScene *menu = [[DLMenuScene alloc]initWithSize:self.size];
            [self cleanUpChildrenAndRemove:self];
            [self.view presentScene:menu transition:[SKTransition fadeWithDuration:.5]];
        }
        //    [_scoreLabel removeAllActions];
        
    }else{
        
        if (_player.touched){
        }
    }
    _player.touched = NO;
    
}

-(void)update:(CFTimeInterval)currentTime {
    if (self.player.touched){
        [_player.physicsBody applyForce:CGVectorMake((_player.endLocation.x - _player.position.x) * _playerPullForceScale, (_player.endLocation.y - _player.position.y )*_playerPullForceScale) atPoint:CGPointMake(_player.position.x, _player.position.y)] ;
    }
    
    if (!_gameState.isCountdown){
        if (!_gameState.isGameOver) {
            
            CFTimeInterval thisFrameStartTime = CFAbsoluteTimeGetCurrent();
            float deltaTimeInSeconds = thisFrameStartTime - _startTime;
            _timeLeft = _gameState.totalTime-deltaTimeInSeconds;
            _timeLabel.text = [NSString stringWithFormat:@"%.0f sec", _timeLeft ];
            
            
            if (deltaTimeInSeconds > _gameState.totalTime && !_gameState.isGameOver) {
                _gameState.isGameOver = YES;
                [self doGameOver];
            }
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (!_gameState.isGameOver) {
        if (contact.bodyB.node == _ball){
            //start clock on first nock
            if (_gameState.isCountdown){
                _gameState.isCountdown = NO;
                _startTime = CFAbsoluteTimeGetCurrent();
            }
            
            _gameState.playerScore += 1;
            if (_poweredUp){
                
                [_timeBonusEmitter removeFromParent];
                SKEmitterNode *timeBooster = [_timeBonusEmitter copy];
                timeBooster.position = _ball.position;
                [_field addChild:timeBooster];
                
                SKAction *moveToTime = [SKAction moveTo:_timeLabel.position duration:0.2];
                [timeBooster runAction:moveToTime completion:^{
                    [timeBooster removeFromParent];
                }];
                
                _poweredUp = NO;
                _gameState.totalTime += _timeBonus;
                
                _timeBonus = 0;
            }
            
            [_player runAction:[SKAction playSoundFileNamed:_gameState.theme.hitSound waitForCompletion:NO]];
            [_scoreLabel runAction:_scorePopAction];
            
            
            _scoreLabel.text = [NSString stringWithFormat: @"%ld",(long)_gameState.playerScore ];
            
            //_player.touched = NO;
            if (_gameState.playerScore > _gameState.currentTarget){
                
                [self updateHUD];
            }
            
            SKEmitterNode *collision = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"crash" ofType:@"sks"]];
            
            collision.position = contact.contactPoint;
            collision.zPosition = 500;
            [_field addChild:collision];
        }else{
            //hit wall and power up
            if (!_poweredUp){
                
                [_ball addChild:_timeBonusEmitter];
                
                _timeBonus = 1;
                _poweredUp = YES;
            }
        }
    }
}

- (void)loadSettings {
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"NockSettings" ofType:@"plist"];
    self.settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
}

- (void)scaleForcesForiPhone {
    self.playerFlickForceScale *= 1.8;
    self.playerPullForceScale *= 1.8;
}

- (void)setupPhysics {
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
    self.playerPullForceScale = [(NSNumber *)_settingsDictionary[@"playerPullForceScale"] integerValue];
    self.playerFlickForceScale = [(NSNumber *)_settingsDictionary[@"playerFlickForceScale"] integerValue];
    if (!IPAD){
        [self scaleForcesForiPhone];
    }
}

- (void)orderZPositions {
    _field.zPosition = 10;
    _timeLabel.zPosition = 200;
    _scoreLabel.zPosition = 200;
    _targetScoreLabel.zPosition = 200;
    _ball.zPosition = 50;
    _ball.trail.particleZPosition = 40;
    _player.zPosition = 50;
    _player.trail.particleZPosition = 40;
}

-(void)setUpField
{
    //create walls
    _field = [SKNode node];
    _field.zPosition = 10;
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.background];
    sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
    [_field addChild:sprite];
    
    
    CGMutablePathRef ellipse = CGPathCreateMutable();
    CGPathAddEllipseInRect(ellipse, NULL, CGRectMake(10, 10, self.size.width-20, self.size.height-20));
    SKShapeNode *boundary = [SKShapeNode node];
    boundary.path = ellipse;
    boundary.strokeColor = _gameState.theme.fontColor;
    boundary.lineWidth = 10;
    [_field addChild:boundary];
    
    CGPathAddEllipseInRect(ellipse, NULL, CGRectMake(20, 20, self.size.width-40, self.size.height-40));
    
    _field.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:ellipse];
    _field.physicsBody.dynamic = NO;
    
    
    [self addChild:_field];
    
    
}



-(void)setUpPlayer
{
    //create player
    _player = [DLPuck node];
    
    if (IPAD) {
        _player = [_player initWithRadius:[(NSNumber *)_settingsDictionary[@"playerSizeIPad"] integerValue] settings:self.settingsDictionary];
        _player.position = CGPointMake(self.size.width/4, self.size.height/2);
    } else {
        _player = [_player initWithRadius:[(NSNumber *)_settingsDictionary[@"playerSizeIPhone"] integerValue] settings:self.settingsDictionary];
        _player.position = CGPointMake(self.size.width/2, self.size.height/4);
    }
    [self addChild:_player];
    
    _player.zPosition = 50;
    _player.trail = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"trail" ofType:@"sks"]];
    //set particle image
    _player.trail.particleTexture = [SKTexture textureWithImageNamed:_gameState.theme.playerTrail];
    _player.sprite = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.playerSprite];
    _player.sprite.name = @"player";
    
    
    _player.physicsBody.linearDamping = 1;
    _player.physicsBody.categoryBitMask = CollisionPlayer;
    _player.physicsBody.contactTestBitMask = CollisionBall;
    _player.physicsBody.mass = [(NSNumber *)_settingsDictionary[@"playerMass"] integerValue];
    
}

-(void)setUpOpponents
{
    //create balls
    _ball = [DLPuck node];
    if (IPAD) {
        _ball = [_ball initWithRadius:[(NSNumber *)_settingsDictionary[@"ballSizeIPad"] integerValue] settings:self.settingsDictionary];
        _ball.position = CGPointMake(self.size.width*3/4, self.size.height/2);
    } else {
        _ball = [_ball initWithRadius:[(NSNumber *)_settingsDictionary[@"ballSizeIPhone"] integerValue] settings:self.settingsDictionary];
        _ball.position = CGPointMake(self.size.width/2, self.size.height*3/4);
    }
    [self addChild:_ball];
    _ball.trail = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ballTrail" ofType:@"sks"]];
    _ball.trail.name = @"ballTrail";
    _ball.trail.particleTexture = [SKTexture textureWithImageNamed:_gameState.theme.ballTrail];
    
    _ball.sprite = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.ballSprite];
    _ball.physicsBody.linearDamping = .4;
    _ball.physicsBody.categoryBitMask = CollisionBall;
    
}


////////////////////////////////////    H U D    ////////////////////////////////////

-(void)setupHUD{
    _hud = [SKNode node];
    
    
    SKNode *targetScore = [SKNode node];
    
    SKSpriteNode *targetPlayerSprite;
    if ([_gameState nextTarget].photo){
        targetPlayerSprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[_gameState nextTarget].photo]];
    }else{
        targetPlayerSprite = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.ballSprite];
    }
    
    targetPlayerSprite.name = @"targetSprite";
    targetPlayerSprite.size = CGSizeMake(50.0, 50.0);
    targetPlayerSprite.position = CGPointMake(self.size.width-50.0, self.size.height-50.0);
    [targetScore addChild:targetPlayerSprite];
    
    SKNode *playerScore = [SKNode node];
    SKSpriteNode *playerSprite ;
    
    if (_gameState.player.photo){
        playerSprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:_gameState.player.photo]];
    }else{
        playerSprite = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.playerSprite];
    }
    playerSprite.name = @"playerSprite";
    playerSprite.size = CGSizeMake(50.0, 50.0);
    playerSprite.position = CGPointMake(50.0, self.size.height-50.0);
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _scoreLabel.fontSize = 50;
    _scoreLabel.fontColor = _gameState.theme.fontColor;
    _scoreLabel.position = CGPointMake(50, self.size.height-130);
    _scoreLabel.text = @"0";
    
    _scoreLabelName = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _scoreLabelName.fontSize = 50;
    _scoreLabelName.fontColor = _gameState.theme.fontColor;
    _scoreLabelName.position = CGPointMake(20, self.size.height-70);
    _scoreLabelName.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabelName.text = @"Score";
    _scoreLabelName.zPosition = 200;
    
    _targetScoreLabel = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _targetScoreLabel.fontSize = 50;
    _targetScoreLabel.fontColor = _gameState.theme.fontColor;
    _targetScoreLabel.position = CGPointMake(self.size.width-50, self.size.height-130);
    _targetScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_gameState.player.highScore];
    
    _targetScoreLabelName = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _targetScoreLabelName.fontSize = 50;
    _targetScoreLabelName.zPosition = 200;
    _targetScoreLabelName.fontColor = _gameState.theme.fontColor;
    _targetScoreLabelName.position = CGPointMake(self.size.width-2, self.size.height-70);
    _targetScoreLabelName.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _targetScoreLabelName.text = [NSString stringWithFormat:@"Best"];
    
    
    _timeLabel = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _timeLabel.fontSize = 50;
    _timeLabel.fontColor = _gameState.theme.fontColor;
    _timeLabel.position = CGPointMake(self.size.width/2, self.size.height- 60);
    _timeLabel.text = @"10 sec";
    
    _timeBonusEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"timeBonusEmitter" ofType:@"sks"]];
    _timeBonusEmitter.particleZPosition = 45;
    
    
    //[_hud addChild:_scoreBar];
    if (!IPAD) {
        //adjust for portrait iPhone
        
        targetPlayerSprite.size = CGSizeMake(40.0, 40.0);
        targetPlayerSprite.position = CGPointMake(self.size.width-30.0, self.size.height-30.0);
        
        playerSprite.size = CGSizeMake(40.0, 40.0);
        playerSprite.position = CGPointMake(30.0, self.size.height-30.0);
        
        _scoreLabel.fontSize = 25;
        _scoreLabel.position = CGPointMake(35, self.size.height-48);
        _scoreLabelName.fontSize = 25;
        _scoreLabelName.position = CGPointMake(5, self.size.height-24);
        
        _targetScoreLabel.fontSize = 25;
        _targetScoreLabel.position = CGPointMake(self.size.width-30, self.size.height-48);
        _targetScoreLabelName.fontSize = 25;
        _targetScoreLabelName.position = CGPointMake(self.size.width-10, self.size.height-24);
        
        _timeLabel.fontSize = 20;
        _timeLabel.position = CGPointMake(self.size.width/2, self.size.height- 40);
        
    }
    
    [playerScore addChild:playerSprite];
    [playerScore addChild:_scoreLabelName];
    [playerScore addChild:_scoreLabel];
    [targetScore addChild:_targetScoreLabelName];
    [targetScore addChild:_targetScoreLabel];
    
    [_hud addChild:playerScore];
    [_hud addChild:targetScore];
    
    [_hud addChild:_timeLabel];
    
    [self addChild:_hud];
    
}

-(void)updateHUD{
    
}

////////////////////////////////////    GAME OVER    ////////////////////////////////////
-(void)doGameOver{
    
    [self removeActiveGameLabels];
    
    if (_gameState.playerScore > _gameState.player.highScore){
        _gameState.player.highScore = _gameState.playerScore;
    }
    _gameState.player.totalScore += _gameState.playerScore;
    [_gameState persist];
    SKAction *crash = [SKAction playSoundFileNamed:_gameState.theme.gameOverSound waitForCompletion:YES];
    [_field runAction:crash];
    [_gameKitHelper persistScoreswithCompletionHandler:^(id ibject) {
        nil;
    }];
    
    SKLabelNode *scoreLine = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    scoreLine.text = [NSString stringWithFormat:@"You scored %ld",(long)_gameState.playerScore];
    scoreLine.fontColor = _gameState.theme.fontColor;
    scoreLine.position =  CGPointMake(self.size.width/2,self.size.height/2);
    scoreLine.fontSize = 48;
    scoreLine.zPosition = 200;
    
    
    SKLabelNode *challenge = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    if (_gameState.lastTarget.name){
        challenge.text = [NSString stringWithFormat:@"Challenge %@ (%ld)",_gameState.lastTarget.name,(long)_gameState.lastTarget.highScore];
    }
    challenge.fontColor = _gameState.theme.fontColor;
    challenge.position =  CGPointMake(self.size.width/2,self.size.height*2/5);
    challenge.fontSize = 32;
    
    
    SKLabelNode *done = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    done.text = [NSString stringWithFormat:@"Done"];
    done.fontColor = _gameState.theme.fontColor;
    done.position =  CGPointMake(self.size.width/2,self.size.height*1/5);
    done.fontSize = 64;
    done.zPosition = 200;
    done.name = @"Done";
    
    
    if (!IPAD){
        scoreLine.fontSize = 34;
    }
    
    SKAction *shrink = [SKAction scaleTo:0 duration:0.1];
    SKAction *zoom = [SKAction scaleTo:1 duration:2];
    SKAction *drop = [SKAction moveTo:CGPointMake(self.size.width/2,self.size.height/2) duration:1];
    SKAction *group = [SKAction group:@[zoom,[drop reversedAction]]];
    SKAction *sequence = [SKAction sequence:@[shrink,group]];
    [_field addChild:scoreLine];
    [done runAction:sequence];
    [_field addChild:done];
    
    _player.physicsBody.linearDamping=0;
    _ball.physicsBody.linearDamping=0;
}

- (void)removeActiveGameLabels {
    [_timeLabel removeFromParent];
    [_scoreLabel removeFromParent];
    [_scoreLabelName removeFromParent];
    [_timeBonusEmitter removeFromParent];
    [_targetScoreLabelName removeFromParent];
    [_targetScoreLabel removeFromParent];
}

- (void)cleanUpChildrenAndRemove:(SKNode*)node {
    for (SKNode *child in node.children) {
        [self cleanUpChildrenAndRemove:child];
    }
    [node removeFromParent];
}


@end