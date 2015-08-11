
import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO Setup gamekit
        
        let scene = DLMenuScene(size:view.bounds.size)

        let gameView = SKView()
        view = gameView
        gameView.presentScene(scene)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact {
            return .Portrait
        } else {
            return .LandscapeLeft
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

