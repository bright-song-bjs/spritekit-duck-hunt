import Foundation
import SpriteKit


class Shared
{
    static let sharedInstance = Shared()
    
    var currentScene: SKScene?
    var stageScene: StageScene?
    
    private init() {}
    
    func registerScene(_ scene: SKScene)
    {
        self.currentScene = scene
        
        if let stageScene = scene as? StageScene
        {
            self.stageScene = stageScene
        }
    }
}
