
import SpriteKit

class Puck: SKNode {
    
    var trail:SKEmitterNode? {
        didSet{
            trail?.particleSize = CGSize(width: radius * 3, height: radius * 3)
            trail?.targetNode = parent
            addChild(trail!)
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
    var releasePoint = CGPoint()
    
    override init() {
        self.trail = SKEmitterNode()
        self.radius = 0
        super.init()
    }

    init(radius: Int, trail: SKEmitterNode?){
        self.radius = radius
        self.trail = trail
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.trail = SKEmitterNode()
        self.radius = 0
        super.init(coder: aDecoder)
    }
    
    func setupPhysics(){
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
        physicsBody?.restitution = 0.7
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 10
        physicsBody?.linearDamping = 1
    }
    
    
}
