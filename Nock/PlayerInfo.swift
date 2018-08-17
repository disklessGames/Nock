
import UIKit

class PlayerInfo: NSObject {
    let playerId: String
    @objc let name: String
    @objc var highScore = 0
    @objc var totalScore = 0
    @objc var photo: UIImage? = nil
    
    @objc init(playerId: String, name: String, highScore: Int, totalScore: Int, photo: UIImage?){
        self.playerId = playerId
        self.name = name
        self.highScore = highScore
        self.totalScore = totalScore
        self.photo = photo
    }
}
