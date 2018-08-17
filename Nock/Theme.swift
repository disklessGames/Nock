
import UIKit


class Theme: NSObject {
    @objc let name: String
    @objc let font: String
    @objc let fontColor: UIColor
    @objc let playerSprite: String
    @objc let playerTrail: String
    @objc let ballSprite: String
    @objc let ballTrail: String
    @objc let background: String
    @objc let ballHitSound: String
    @objc let slideSound: String
    @objc let gameOverSound: String
    
    init(themeInfo: [String: String]){
        self.name = themeInfo["name"]!
        self.font = themeInfo["font"]!
        if themeInfo["fontColor"]! == "white" {
            self.fontColor = UIColor(white: 1, alpha: 1)
        }else {
            self.fontColor = UIColor(white: 0, alpha: 1)
        }
        self.playerSprite = themeInfo["playerSprite"]!
        self.playerTrail = themeInfo["playerTrail"]!
        self.ballSprite = themeInfo["ballSprite"]!
        self.ballTrail = themeInfo["ballTrail"]!
        self.background = themeInfo["background"]!
        self.ballHitSound = themeInfo["ballHitSound"]!
        self.slideSound = themeInfo["slideSound"]!
        self.gameOverSound = themeInfo["gameOverSound"]!
    }
}
