//
//  ViewController.m
//  Nock
//
//  Created by Jannie Theron on 2014/05/12.
//  Copyright (c) 2014 pantsula. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "DLGameKitHelper.h"
//#import "GADBannerView.h"


@implementation ViewController {
    SKView *_skView;
    BOOL _alreadyLoaded;
    BOOL _bannerIsVisible;
    //    GADBannerView *bannerView_;
    BOOL _enableAds;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)viewWillLayoutSubviews
{
    _enableAds = YES;
    if (!_alreadyLoaded){
        
        
        [super viewWillLayoutSubviews];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        _bannerIsVisible = NO;
        
        _skView = (SKView *)self.view;
        _skView.showsFPS = NO;
        _skView.showsNodeCount = NO;

        SKScene * scene = [DLMenuScene sceneWithSize:_skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeFill;
        [_skView presentScene:scene];

        [DLGameKitHelper sharedGameKitHelper].authenticationViewController = self;

        _alreadyLoaded = YES;
        

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //gamecenter notification handler
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];

    [[DLGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)showAuthenticationViewController
{
    DLGameKitHelper *gameKitHelper =
    [DLGameKitHelper sharedGameKitHelper];
    
    [self presentViewController:
     gameKitHelper.authenticationViewController
                       animated:YES
                     completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)willEnterForeground {
    _skView.paused = NO;

}

- (void)willEnterBackground {
    // pause it and remember to resume the animation when we enter the foreground
    _skView.paused = YES;
    [[DLGameKitHelper sharedGameKitHelper] persistScoreswithCompletionHandler: ^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

