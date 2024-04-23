import UIKit
import SpriteKit


class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let view = self.view as? SKView
        {
            if let stageScene = SKScene(fileNamed: "StageScene")
            {
                stageScene.scaleMode = .aspectFit
                view.presentScene(stageScene)
            }
            
            view.ignoresSiblingOrder = false
        }
    }

    override var shouldAutorotate: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all }

    override var prefersStatusBarHidden: Bool { true }
}
