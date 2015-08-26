
#import "DLInfoNode.h"
#import "DLMenuScene.h"
#import "DLGameState.h"

@implementation DLInfoNode{
    DLGameState *_gameState;
}
-(instancetype)init{
    if (self = [super init]){
        
        _gameState = [DLGameState sharedGameState];
        
        int fontsize = 25;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor darkGrayColor] size:self.parent.frame.size];
        background.position = CGPointMake(self.parent.frame.size.width/2, self.parent.frame.size.height/2);
        [self addChild:background];
        
        SKLabelNode *header = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        header.text = @"Rules";
        header.fontSize = 50;
        header.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.8);
        header.zPosition = 225;
        [self addChild:header];
        
        SKLabelNode *line1 = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        line1.text = @"Drag or flick the red puck";
        line1.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.7);
        line1.fontSize = 25;
        line1.zPosition = 225;
        [self addChild:line1];
        
        SKLabelNode *line2 = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        line2.text = @"Hit the ball to score";
        line2.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.6);
        line2.fontSize = fontsize;
        line2.zPosition = 225;

        [self addChild:line2];
        
        SKLabelNode *line3 = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        line3.text = @"Hit the sides to charge";
        line3.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.5);
        line3.fontSize = fontsize;
        [self addChild:line3];
        
        SKLabelNode *line4 = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        line4.text = @"Score to add time";
        line4.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.4);
        line4.fontSize = fontsize;
        [self addChild:line4];
        
        SKLabelNode *myAd = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        myAd.text = @"You start with 5 sec.";
        myAd.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.3);
        myAd.fontSize = fontsize;
        [self addChild:myAd];

        SKLabelNode *myAd2 = [[SKLabelNode node]initWithFontNamed:_gameState.theme.font];
        myAd2.text = @"";
        myAd2.position = CGPointMake(self.parent.frame.size.width/2,self.parent.frame.size.height*0.2);
        myAd2.fontSize = fontsize;
        [self addChild:myAd2];

    }
    return self;
}
@end
