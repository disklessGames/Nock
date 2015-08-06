
import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup gamekit
        
        let gameView = SKView()
        
        let scene = DLMenuScene(size:view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.Fill
        view = gameView
        gameView.presentScene(scene)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact {
            return .Portrait
        } else {
            return .Landscape
        }
    }
}

