
import Foundation

class GameState: NSObject {
    
    @objc static let shared = GameState()
    
    @objc var totalTime = 10
    @objc var player: PlayerInfo?
    @objc var playerScore = 0
    @objc var isCountdown = true
    @objc var isGameOver = false
    @objc let currentTarget = 0
    @objc var friends = [String: PlayerInfo]()
    let themes: [String]
    @objc var currentTheme: Theme
    var currentThemeIndex = 0
    
    private let defaults = UserDefaults.standard
    private let settings: [String: AnyObject]
    
    
    override init() {
        let plistPath = Bundle.main.path(forResource: "NockSettings", ofType: "plist")!
        self.settings = NSDictionary(contentsOfFile: plistPath) as! [String : AnyObject]
        self.themes = self.settings["themes"]! as! [String]
        self.currentThemeIndex = defaults.integer(forKey: "selectedTheme")
        let themeSettings = self.settings[self.themes[self.currentThemeIndex]] as! [String: String]
        self.currentTheme = Theme(themeInfo: themeSettings)
        super.init()
    }
    
    @objc func resetGame() {
        totalTime = 10
        playerScore = 0
        isCountdown = true
        isGameOver = false
    }
    
    @objc func nextTarget() -> PlayerInfo? {
        return friends.sorted { $0.1.highScore > $1.1.highScore }
            .filter { $0.1.highScore > playerScore }
            .first?.1
    }
    
    @objc func previousTarget() -> PlayerInfo? {
        return friends.sorted { $0.1.highScore > $1.1.highScore }
            .filter { $0.1.highScore < playerScore }
            .first?.1
    }
    
    @objc func persist() {
        if let player = player {
            defaults.set(player.highScore, forKey: "highScore")
            defaults.set(player.totalScore, forKey: "totalScore")
        }
    }
    
    @objc func loadNextTheme() {
        currentThemeIndex += 1
        if currentThemeIndex >= themes.count {
            currentThemeIndex = 0
        }
        defaults.set(currentThemeIndex, forKey: "selectedTheme")
        let themeSettings = self.settings[self.themes[self.currentThemeIndex]] as! [String: String]
        currentTheme = Theme(themeInfo: themeSettings)
    }
}
