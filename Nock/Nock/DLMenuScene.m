//
//  DLMenuScene.m
//  Nock
//
//  Created by Jannie Theron on 2014/05/14.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import "DLMenuScene.h"
#import "DLGameScene.h"
#import "DLGameKitHelper.h"
#import "DLInfoNode.h"
#import "DLGameState.h"
#import "DLLeaderboard.h"

@interface DLMenuScene()

@property DLInfoNode *info;
@property DLGameState *gameState;
@property DLLeaderboard *leaderboard;
@property SKEmitterNode *highlight;
@property SKNode *selectedNode;
@property SKAction *selectAction;
@property SKLabelNode *titleButton;
@property SKLabelNode *themeButton;
@property SKLabelNode *scoresButton;
@property SKSpriteNode *backGround;

@end

@implementation DLMenuScene{
}

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        _gameState = [DLGameState sharedGameState];//TODO Bad idea
        
        [self setupBackground];
        [self setupSelectionHighlight];
        [self setupTitleButton];
        [self setupTitleZoomLoop];
        [self setupScoresButton];
        [self setupThemeButton];
        [self setupLeaderboard];
        [self adaptForiPhone];
        [self applyTheme];
    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime {
    NSLog(@"Update called at %f",currentTime);
}

- (void)setupSelectionHighlight {
    _highlight = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"menuHighlight" ofType:@"sks"]];
    _highlight.zPosition = 5;
    _highlight.name = @"highlight";
    _selectAction = [SKAction scaleBy:1.2 duration:0.05];
    
}

- (void)setupTitleZoomLoop {
    SKAction *hint = [SKAction scaleBy:0.99 duration:0.05];
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *pause = [SKAction waitForDuration:0.1];
    SKAction *seq = [SKAction sequence:@[wait,hint,pause,[hint reversedAction]]];
    [_titleButton runAction:[SKAction repeatActionForever:seq]];
    [self addChild:_titleButton];
    
}

- (void)setupTitleButton {
    _titleButton = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _titleButton.fontSize = 300;
    _titleButton.text = @"Nock";
    _titleButton.position = CGPointMake(self.size.width/2, self.size.height*0.60);
    _titleButton.name = @"startButton";
    _titleButton.zPosition = 10;
    _titleButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _titleButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
}

- (void)setupScoresButton {
    _scoresButton = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _scoresButton.fontSize = 45;
    _scoresButton.text = [NSString stringWithFormat: @"Last - %ld Best - %ld Total - %ld",(long)_gameState.playerScore,(long)_gameState.player.highScore,(long)_gameState.player.totalScore];
    _scoresButton.fontColor = _gameState.theme.fontColor;
    _scoresButton.name = @"scoresButton";
    _scoresButton.position = CGPointMake(self.size.width/2, self.size.height*0.35);
    _scoresButton.zPosition = 10;
    _scoresButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _scoresButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:_scoresButton];
}

- (void)setupThemeButton {
    _themeButton = [SKLabelNode labelNodeWithFontNamed:_gameState.theme.font];
    _themeButton.fontSize = 45;
    _themeButton.text = @"Theme";
    _themeButton.fontColor = _gameState.theme.fontColor;
    _themeButton.position = CGPointMake(self.size.width/2, self.size.height*0.25);
    _themeButton.name = @"themesButton";
    _themeButton.zPosition = 10;
    _themeButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _themeButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:_themeButton];
}

- (void)adaptForiPhone {
    if (!IPAD){
        _titleButton.fontSize = 90;
        _scoresButton.fontSize = 25;
        _scoresButton.text = [NSString stringWithFormat: @"Last - %ld Best - %ld",(long)_gameState.playerScore,(long)_gameState.player.highScore];
        _themeButton.fontSize = 30;
        _themeButton.position = CGPointMake(self.size.width/2, _themeButton.position.y);
    }
}

- (void)setupBackground {
    _backGround = [SKSpriteNode spriteNodeWithImageNamed:_gameState.theme.background];
    _backGround.position = CGPointMake(self.size.width/2, self.size.height/2);
    _backGround.zPosition = 5;
    [self addChild:_backGround];
    [self selectNode:_backGround];
}

- (void)setupLeaderboard {
    NSDictionary *allScores;
    if (_gameState.highScores && _gameState.totalScores){
        
        allScores = [NSDictionary dictionaryWithObjects:@[_gameState.highScores,_gameState.totalScores] forKeys:@[@"High Scores",@"Total Nocks"]];
    }else{
        allScores = [NSDictionary dictionaryWithObjects:@[@[_gameState.player],@[_gameState.player]] forKeys:@[@"High Scores",@"Total Nocks"]];
        //create dictionary with local scores
    }
    _leaderboard = [[DLLeaderboard alloc]initWithSize:self.size atPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _leaderboard.scores = allScores;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    [self selectNode:node];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    [self changeSelectedNodeTo:node];
}

- (void)changeSelectedNodeTo:(SKNode *)node {
    if ([node.name isEqualToString:@"highlight"]) {
        node = node.parent;
    }
    
    if (node != _selectedNode){
        [self selectNode:node];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"highlight"]) {
        node = node.parent;
    }
    DLGameKitHelper *gameKitHelper = [DLGameKitHelper sharedGameKitHelper];
    [_info removeFromParent];
    [_leaderboard removeFromParent];
    
    if (![node.name isEqualToString:@"background"]){
        if ([node.name isEqualToString:@"scoresButton"]){
            [gameKitHelper updateAndShowGameCenter];
        }else if ([node.name isEqualToString:@"themesButton"]){
            [_gameState loadNextTheme];
            [self applyTheme];
        }else if ([node.name isEqualToString: @"startButton"] ){
            [[DLGameState sharedGameState] resetGame];
            DLGameScene *game = [[DLGameScene alloc]initWithSize:self.size];
            [self.view presentScene:game transition:[SKTransition fadeWithDuration:.5]];
        }
        
        [self removeSelection];
    }
    
}

-(void)selectNode:(SKNode *)node{
    [self removeSelection];
    if ([node.name isEqualToString:@"startButton"]||
        [node.name isEqualToString:@"themesButton"]||
        [node.name isEqualToString:@"scoresButton"]){
        
        _selectedNode = node;
        
        _selectedNode.alpha = .8;
        [_selectedNode runAction:_selectAction];
        
        _highlight.particleBirthRate = _selectedNode.frame.size.width/10;
        _highlight.particlePositionRange = CGVectorMake(_selectedNode.frame.size.width,_selectedNode.frame.size.height);
        [_selectedNode addChild:_highlight];
        [_selectedNode runAction:[SKAction playSoundFileNamed:_gameState.theme.hitSound waitForCompletion:YES]];
    }
}

-(void)removeSelection{
    if ([_selectedNode.name isEqualToString:@"startButton"]||
        [_selectedNode.name isEqualToString:@"themesButton"]||
        [_selectedNode.name isEqualToString:@"scoresButton"]){
        
        [_highlight removeFromParent];
        _selectedNode.alpha = 1.0;
        [_selectedNode runAction:[_selectAction reversedAction]];
        _selectedNode = _backGround;
    }
}

-(void)applyTheme{
    _backGround.texture = [SKTexture textureWithImageNamed:_gameState.theme.background];
    
    _titleButton.fontName = _gameState.theme.font;
    _titleButton.fontColor = _gameState.theme.fontColor;
    
    _themeButton.fontName = _gameState.theme.font;
    _themeButton.fontColor = _gameState.theme.fontColor;
    
    _scoresButton.fontName = _gameState.theme.font;
    _scoresButton.fontColor = _gameState.theme.fontColor;
    
}

@end
