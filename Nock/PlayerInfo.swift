
import UIKit

class PlayerInfo: NSObject {
    let playerId: String
    let name: String
    var highScore = 0
    var totalScore = 0
    var photo: UIImage? = nil
    
    init(playerId: String, name: String, highScore: Int, totalScore: Int, photo: UIImage?){
        self.playerId = playerId
        self.name = name
        self.highScore = highScore
        self.totalScore = totalScore
        self.photo = photo
    }
}