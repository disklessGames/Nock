
import SpriteKit

class MenuScene: SKScene {
    let highlight: SKEmitterNode
    var selectedNode: SKNode? = nil
    let selectedAction = SKAction.scaleBy(1.2, duration: 0.05)
    let titleButton: SKLabelNode
    let themeButton: SKLabelNode
    let scoresButton: SKLabelNode
    let background: SKSpriteNode
    let currentTheme = GameState.sharedGameState.currentTheme
    
    override init(size: CGSize) {
        self.highlight = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("menuHighlight", ofType: "sks")!) as! SKEmitterNode
        self.highlight.zPosition = 5
        
        self.background = SKSpriteNode(imageNamed: GameState.sharedGameState.currentTheme.background)
        self.background.zPosition = 5
        
        self.titleButton = SKLabelNode(fontNamed: currentTheme.font)
        
        self.themeButton = SKLabelNode(fontNamed: currentTheme.font)
        
        self.scoresButton = SKLabelNode(fontNamed: currentTheme.font)
        
        super.init(size: size)
        
        self.addChild(self.background)
        self.background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.selectNode(self.background)

        self.titleButton.position = CGPoint(x: size.width/2, y: size.height*0.6)
        self.titleButton.fontSize = 300
        self.titleButton.text = "Nock"
        self.titleButton.zPosition = 10
        self.titleButton.horizontalAlignmentMode = .Center
        self.titleButton.verticalAlignmentMode = .Center
        self.addChild(self.titleButton)
        
        self.themeButton.position = CGPoint(x: size.width/2, y: size.height*0.25)
        self.themeButton.fontSize = 45
        self.themeButton.text = "Theme"
        self.themeButton.fontColor = currentTheme.fontColor
        self.themeButton.zPosition = 10
        self.themeButton.horizontalAlignmentMode = .Center
        self.themeButton.verticalAlignmentMode = .Center
        self.addChild(self.themeButton)
        
        self.scoresButton.position = CGPoint(x: size.width/2, y: size.height*0.35)
        self.scoresButton.fontSize = 45
        self.scoresButton.text = "Last - \(GameState.sharedGameState.playerScore) Best - \(GameState.sharedGameState.player?.highScore) Total - \(GameState.sharedGameState.player?.totalScore)"
        self.scoresButton.fontColor = currentTheme.fontColor
        self.scoresButton.zPosition = 10
        self.scoresButton.horizontalAlignmentMode = .Center
        self.scoresButton.verticalAlignmentMode = .Center
        self.addChild(self.scoresButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func adaptForCompactScreen() {
        titleButton.fontSize = 90
        scoresButton.fontSize = 25
        scoresButton.text = "Last - \(GameState.sharedGameState.playerScore) Best - \(GameState.sharedGameState.player?.highScore)"
        themeButton.fontSize = 30
    }
    
    func selectNode(node: SKNode) {
        removeSelection()
        if isOption(node) {
            selectedNode = node
            selectedNode?.alpha = 0.8
            selectedNode?.runAction(selectedAction)
            highlight.particleBirthRate = selectedNode!.frame.size.width/10
            highlight.particlePositionRange = CGVector(dx: selectedNode!.frame.size.width, dy: selectedNode!.frame.size.height)
            selectedNode?.addChild(highlight)
            selectedNode?.runAction(SKAction.playSoundFileNamed(GameState.sharedGameState.currentTheme.ballHitSound, waitForCompletion: true))
        }
    }
    
    func isOption(node: SKNode) -> Bool {
        return node.name == "startButton" ||
            node.name == "themesButton" ||
            node.name == "scoresButton"
    }
    
    func removeSelection() {
        highlight.removeFromParent()
        selectedNode?.alpha = 1
        selectedNode = background
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let selectedNode = nodeAtPoint(location)
        selectNode(selectedNode)
    }
}
