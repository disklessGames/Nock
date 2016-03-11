//
//  DLPuck.h
//  Nock
//
//  Created by Jannie Theron on 2014/05/13.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DLPuck : SKNode

@property (nonatomic,strong) SKEmitterNode *trail;
@property (nonatomic) SKSpriteNode *sprite;
@property (nonatomic) SKLabelNode *label;
@property (nonatomic) int radius;
@property (nonatomic) BOOL drawDebug;
@property (nonatomic) BOOL touched;
@property (nonatomic) CGPoint endLocation;
- (id) initWithRadius:(double)radius  settings:(NSDictionary *)settingsDictionary ;

@end

