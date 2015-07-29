
#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "DLGameKitHelper.h"


@implementation ViewController {
    SKView *_skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DLGameKitHelper sharedGameKitHelper].authenticationViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:PresentAuthenticationViewController
                                               object:nil];
    
    
    [self setupGameView];
    [self setupMenuScene];
    
}

- (void) setupGameView {
    _skView = (SKView *)self.view;
    _skView.showsFPS = NO;
    _skView.showsNodeCount = NO;
}

- (void)setupMenuScene{
    
    SKScene * scene = [DLMenuScene sceneWithSize:_skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    [_skView presentScene:scene];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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

