
import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup gamekit
        
        let gameView = SKView()
        view = gameView
        
        let scene = SKScene(size: CGSize(width: view.frame.width, height: view.frame.height)) //DLMenuScene(size:gameView.bounds.size)
        
        scene.scaleMode = SKSceneScaleMode.Fill
        gameView.presentScene(scene)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

