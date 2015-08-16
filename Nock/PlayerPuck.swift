
import SpriteKit

class PlayerPuck: Puck {
    
    
    let gameBoard:SKNode
    var pullForce = [500,800]//iPhone,iPad
    var flickForce = [150,200]

    override init() {
        self.gameBoard = SKNode()
        super.init()
    }
    
    init(size: Int, gameBoard: SKNode) {
        let trailFile = NSBundle.mainBundle().pathForResource("trail", ofType: "sks")!
        let trail = NSKeyedUnarchiver.unarchiveObjectWithFile(trailFile) as? SKEmitterNode
        self.gameBoard = gameBoard
        super.init(radius: size, trail: trail)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            releasePoint = touch.locationInNode(gameBoard)
        }
    }
}
