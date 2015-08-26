//
//  MyScene.m
//  Nock
//
//  Created by Jannie Theron on 2014/05/06.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene{
    SKNode *_player;
    SKNode *_field;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //[self setupField];
        [self setupPlayer];
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    [self touchesMoved:touches withEvent:event];
   
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_player runAction:[SKAction moveTo:[[touches anyObject] locationInNode:self]  duration: 1]];
}

-(void)setupPlayer{
     _player = [SKNode node];
        SKShapeNode *circle = [SKShapeNode node];
        circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-20, -20, 40, 40)].CGPath;
        circle.fillColor = [UIColor orangeColor];
        circle.strokeColor = [UIColor orangeColor];
        circle.glowWidth = 15;
        [_player addChild:circle];
        _player.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        [self addChild:_player];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"player.png"];
        [sprite setScale:.5];
        [_player addChild:sprite];

}

-(void)setupField{
    _field = [SKNode node];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"field.png"];
    [_field addChild:sprite];
    [self addChild:_field];
}

@end
