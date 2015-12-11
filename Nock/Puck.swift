
import SpriteKit

class Puck: SKNode {
    let trail: SKEmitterNode
    let sprite: SKSpriteNode
    let radius: CGFloat
    var touching = false
    var endLocation: CGPoint = CGPoint(x: 0, y: 0)
    private let playerPullForceScale: Int
    private let playerFlickForceScale: Int
    
    init(radius: CGFloat, sprite: SKSpriteNode, trail: SKEmitterNode, settings:NSDictionary){
        self.radius = radius
        self.sprite = sprite
        self.trail = trail
        self.trail.particleSize = CGSize(width: radius * 2.75, height: radius * 2.75)
        self.playerPullForceScale = settings["playerPullForceScale"] as? Int ?? 100
        self.playerFlickForceScale = settings["playerFlickForceScale"] as? Int ?? 100
        super.init()
        
        self.trail.targetNode = self.parent
        self.addChild(self.trail)
        
        self.sprite.size = CGSize(width: radius*2, height: radius*2)
        self.addChild(self.sprite)
        
        self.setupPhysics()
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
        physicsBody?.restitution = 0.7
        physicsBody?.allowsRotation = true
        physicsBody?.mass = 10
        physicsBody?.linearDamping = 1
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        updateEndPoint(touches.first!)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateEndPoint(touches.first!)
    }
    
    func updateEndPoint(touch: UITouch) {
        if let parent = self.parent {
            self.endLocation = touch.locationInNode(parent)
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
    }
}
