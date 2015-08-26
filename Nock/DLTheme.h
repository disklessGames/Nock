
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface DLTheme : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *font;
@property (nonatomic, readonly) SKColor  *fontColor;
@property (nonatomic, readonly) NSString *playerSprite;
@property (nonatomic, readonly) NSString *ballSprite;
@property (nonatomic, readonly) NSString *playerTrail;
@property (nonatomic, readonly) NSString *ballTrail;
@property (nonatomic, readonly) NSString *background;
@property (nonatomic, readonly) NSString *hitSound;
@property (nonatomic, readonly) NSString *slideSound;
@property (nonatomic, readonly) NSString *gameOverSound;


-(id)initWithDictionary:(NSDictionary *)themeInfo;
@end