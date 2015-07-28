
#import "DLPuck.h"
#import "DLGameState.h"

@interface DLPuck()

@property NSInteger playerPullForceScale;
@property NSInteger playerFlickForceScale;

@end

@implementation DLPuck

@synthesize sprite = _sprite;
@synthesize trail = _trail;
@synthesize label = _label;
@synthesize radius = _radius;
@synthesize drawDebug = _drawDebug;
@synthesize touched = _touched;

- (instancetype) initWithRadius:(double)radius settings:(NSDictionary *)settingsDictionary {
    self = [super init];
    _radius = radius;
    [self setupPhysics:radius settings:settingsDictionary];
    self.touched = NO;
    self.userInteractionEnabled = YES;
    
    return self;
}

- (void)setupPhysics:(double)radius settings:(NSDictionary *)settingsDictionary {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    self.physicsBody.restitution = 0.7;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass= 10;
    self.physicsBody.linearDamping = 1;

    self.playerPullForceScale = [(NSNumber *)settingsDictionary[@"playerPullForceScale"] integerValue];
    self.playerFlickForceScale = [(NSNumber *)settingsDictionary[@"playerFlickForceScale"] integerValue];
}

-(SKEmitterNode *)trail{
    return _trail;
}

-(void)setTrail:(SKEmitterNode *)trail{
    _trail = trail;
    _trail.particleSize = CGSizeMake(_radius*2.75, _radius*2.75);
    _trail.targetNode = self.parent;
    [self addChild:_trail];
}

-(SKSpriteNode *)sprite{
    return _sprite;
}

-(void)setSprite:(SKSpriteNode *)sprite{
    _sprite = sprite;
    _sprite.size = CGSizeMake(_radius*2, _radius*2);
    [self addChild:_sprite];
}

-(SKLabelNode *)label{
    return _label;
}

-(void)setLabel:(SKLabelNode *)label{
    _label = label;
    
    [self addChild:_label];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touched = YES;
    for (UITouch *touch in touches) {
        self.endLocation = [touch locationInNode:self.parent];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        if (self.touched){
            self.endLocation = [touch locationInNode:self.parent];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touched = NO;
}

-(void)finalFlick {
    [self.physicsBody applyImpulse:CGVectorMake((self.endLocation.x - self.position.x) * _playerFlickForceScale, (self.endLocation.y - self.position.y )*_playerFlickForceScale)] ;
    [self runAction:[SKAction playSoundFileNamed:[DLGameState sharedGameState ].theme.slideSound waitForCompletion:YES]];
}
@end


