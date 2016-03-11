
import UIKit


class Theme: NSObject {
    let name: String
    let font: String
    let fontColor: UIColor
    let playerSprite: String
    let playerTrail: String
    let ballSprite: String
    let ballTrail: String
    let background: String
    let ballHitSound: String
    let slideSound: String
    let gameOverSound: String
    
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