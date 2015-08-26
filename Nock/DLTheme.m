
#import "DLTheme.h"

@implementation DLTheme


-(instancetype)initWithDictionary:(NSDictionary *)themeInfo{
    if (self = [super init]){
        _name = themeInfo[@"name"];
        _font = themeInfo[@"font"];
        NSString *fontColorName = themeInfo[@"fontColor"];
        if ([fontColorName isEqualToString:@"white"]){
            _fontColor = [SKColor whiteColor];
        }else{
            _fontColor = [SKColor blackColor];
        }
        _playerSprite = themeInfo[@"playerSprite"];
        _ballSprite = themeInfo[@"ballSprite"];
        _playerTrail = themeInfo[@"playerTrail"];
        _ballTrail = themeInfo[@"ballTrail"];
        _background = themeInfo[@"background"];
        _hitSound = themeInfo[@"ballHitSound"];
        _slideSound = themeInfo[@"slideSound"];
        _gameOverSound = themeInfo[@"gameOverSound"];
    }
    return self;
}

@end