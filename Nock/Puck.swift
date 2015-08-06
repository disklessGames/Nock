
import SpriteKit

class Puck: SKNode {
    
    var trail:SKEmitterNode {
        didSet{
            trail.particleSize = CGSize(width: radius * 3, height: radius * 3)
            trail.targetNode = parent
            addChild(trail)
        }
    }
    
    var sprite: SKSpriteNode? {
        didSet {
            sprite?.size = CGSize(width: radius * 2, height: radius * 2)
        }
    }
    
    var label: SKLabelNode? {
        didSet {
            if let label = label {
                addChild(label)
            }
        }
    }
    
    var radius = 0
    var touched = false
    var pullForce:Int
    var flickForce:Int
    var gameBoard:SKNode
    var releasePoint = CGPoint()
    
    override init() {
        self.trail = SKEmitterNode()
        self.pullForce = 0
        self.flickForce = 0
        self.radius = 0
        self.gameBoard = SKNode()
        super.init()
    }

    convenience init(radius: Int, pullForce:Int, flickForce:Int, trail: SKEmitterNode, gameBoard: SKNode){
        self.init()
        self.radius = radius
        self.pullForce = pullForce
        self.flickForce = flickForce
        self.trail = trail
        self.gameBoard = gameBoard
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.trail = SKEmitterNode()
        self.pullForce = 0
        self.flickForce = 0
        self.radius = 0
        self.gameBoard = SKNode()
        super.init(coder: aDecoder)
    }
    
    func setupPhysics(pullForce:Int, flickForce:Int){
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
        physicsBody?.restitution = 0.7
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 10
        physicsBody?.linearDamping = 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            releasePoint = touch.locationInNode(gameBoard)
        }
    }
}
