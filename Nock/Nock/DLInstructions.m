//
//  DLInstructions.m
//  Nock
//
//  Created by Jannie Theron on 2014/05/20.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import "DLInstructions.h"
#import "DLMenuScene.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation DLInstructions

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        SKSpriteNode *sprite = [SKSpriteNode node];
        if (IPAD){
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"InstructionsIPad"];
        }else{
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"InstructionsIPhone5"];
        }
        sprite.size = self.size;
        double escalax =        self.size.width/ sprite.size.width  ;
        double escalay =        self.size.height/ sprite.size.height  ;
        
        
        SKAction *mostrar = [SKAction scaleXTo:escalax y:escalay duration:0];
        [sprite runAction:mostrar];
        sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        [self addChild:sprite];
        SKAction *wait = [SKAction waitForDuration:3];
        [self runAction:wait completion:^{
            //Show menu
            DLMenuScene *menu = [[DLMenuScene alloc]initWithSize:self.size];
            [self.view presentScene:menu transition:[SKTransition fadeWithDuration:.5]];

        }];
    }
    return self;
}
@end
