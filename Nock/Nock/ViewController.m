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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enableAds)
                                                     name:DLShowAds
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(disableAds)
                                                     name:DLHideAds
                                                   object:nil];
        _bannerIsVisible = NO;
        
        _skView = (SKView *)self.view;
    
        _skView.showsFPS = NO;
        _skView.showsNodeCount = NO;
    
    
        // Create and configure the scene.
        SKScene * scene = [DLMenuScene sceneWithSize:_skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeFill;
        
        [DLGameKitHelper sharedGameKitHelper].authenticationViewController = self;
    
        // Present the scene.
        [_skView presentScene:scene];
        
        _alreadyLoaded = YES;
        
        // Create a view of the standard size at the top of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
   /*     if (_enableAds){
            if (IPAD){
                bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, _skView.frame.size.width - 90)];
            
            }else{
                bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, self.view.frame.size.height - 50)];
            }
        
                // Specify the ad unit ID.
            bannerView_.adUnitID = @"ca-app-pub-2708452885699303/6604844071";
        
            // Let the runtime know which UIViewController to restore after taking
            // the user wherever the ad goes and add it to the view hierarchy.
            bannerView_.rootViewController = self;
            [self.view addSubview:bannerView_];
        
            // Initiate a generic request to load it with an ad.
            //GADRequest *request = [GADRequest request];
        
            // Make the request for a test ad. Put in an identifier for
            // the simulator as well as any devices you want to receive test ads.
            request.testDevices = [NSArray arrayWithObjects:
                               @"c30e562705afd4e1778609c955839be1",
                               @"fa8a1a90455ec018ebd5e910d59d6642",
                               nil];
    
            //request.testDevices = @[ @"fa8a1a90455ec018ebd5e910d59d6642" ];
            
            [bannerView_ loadRequest:[GADRequest request]];

            bannerView_.hidden=YES;
        }
*/
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

-(void)enableAds{

    if (_enableAds){
  //      _bannerIsVisible = YES;
  //      bannerView_.hidden = NO;
    }
}

-(void)disableAds{
    
    if (_enableAds){
 //       _bannerIsVisible = NO;
 //       bannerView_.hidden = YES;
    }
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

