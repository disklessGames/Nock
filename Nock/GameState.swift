
import Foundation

class GameState: NSObject {
    
    static let sharedGameState = GameState()
    
    var totalTime = 10
    let player = DLPlayerInfo()
    var playerScore = 0
    var isCountdown = true
    var isGameOver = false
    let currentTarget = 0
    var friends = [String: DLPlayerInfo]()
    let themes: [String]
    var currentTheme: Theme
    var currentThemeIndex = 0
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let settings: [String: AnyObject]
    
    
    override init() {
        let plistPath = NSBundle.mainBundle().pathForResource("NockSettings", ofType: "plist")!
        self.settings = NSDictionary(contentsOfFile: plistPath) as! [String : AnyObject]
        self.themes = self.settings["themes"]! as! [String]
        self.currentThemeIndex = defaults.integerForKey("selectedTheme")
        let themeSettings = self.settings[self.themes[self.currentThemeIndex]] as! [String: String]
        self.currentTheme = Theme(themeInfo: themeSettings)
            super.init()
    }
    
    func resetGame() {
        totalTime = 10
        playerScore = 0
        isCountdown = true
        isGameOver = false
    }
    
    func nextTarget() -> DLPlayerInfo? {
        return friends.sort { $0.1.highScore > $1.1.highScore }.filter { $0.1.highScore > playerScore }.first?.1
    }
    
    func previousTarget() -> DLPlayerInfo? {
        return friends.sort { $0.1.highScore > $1.1.highScore }.filter { $0.1.highScore < playerScore }.first?.1
    }
    
    func persist() {
        defaults.setInteger(player.highScore, forKey: "highScore")
        defaults.setInteger(player.totalScore, forKey: "totalScore")
    }
    
    func loadNextTheme() {
        currentThemeIndex += 1
        if currentThemeIndex >= themes.count {
            currentThemeIndex = 0
        }
        defaults.setInteger(currentThemeIndex, forKey: "selectedTheme")
        let themeSettings = self.settings[self.themes[self.currentThemeIndex]] as! [String: String]
        currentTheme = Theme(themeInfo: themeSettings)
    }
}