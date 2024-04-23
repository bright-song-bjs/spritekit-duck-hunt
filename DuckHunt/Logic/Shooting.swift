import Foundation
import SpriteKit


class Shooting
{
    //score settings
    let scoreMultiplier: Double = 0.2
    let targetThreshold: Int = 5
    let scoreTextOffset: (x: Double, y: Double) = (-20, 50)
    
    //shooting settings
    let shootDelay: Double = 0.11
    


    //scene
    unowned var stageScene: StageScene
    
    //score
    var targetCount:Int = 0
    var currentScoreMultiplier: Double = 1
    var currentScore: Double = 0
    {
        didSet
        {
            let text = String(Int(self.currentScore))
            self.stageScene.updateScoreText(score: text)
        }
    }
    var recordScore: Double = UserDefaults.standard.double(forKey: "RecordScore")
    
    
    init (stageScene: StageScene)
    {
        self.stageScene = stageScene
        
        //update score text since the default value is 0, and it won't be set to 0 in init, so it has to be updated manully the first time
        self.stageScene.updateScoreText(score: "0")
    }
    
    func shoot()
    {
        //audio and haptic
        Audio.sharedInstance.playSound(soundFileName: Sound.hit.fileName)
        Utilities.impactFeedback_rigid()
        
        //magezine UI change
        self.stageScene.magazine.shoot()
        
        //get actual shot position
        let position = self.stageScene.crosshair.position
        
        //delay for sometime then actual shoot
        self.stageScene.run(.sequence([
            //wait for some time
            .wait(forDuration: self.shootDelay),
            .run
            {
                //check whether shot duck/targetDuck/target or not then get the node
                let result = self.findShotNode(at: position)
                guard let shootable = result.shootable else { return }
                guard let shotNode = result.shotNode else { return }
        
                //get shotMarkName and add shotMark to the shot node
                let shotMarkName = shootable.shotMarkImageName ?? Image.shotBlue.imageName
                Utilities.addImageToNode(in: self.stageScene, imageNamed: shotMarkName, xScale: 0.65, yScale: 0.65, to: shotNode, at: position, willDisappear: true, waitTime: 1.5, fadeTime: 1.5)
              
                //get score if it has and add score text to scene
                if let score = shootable.score
                {
                    //audio
                    Audio.sharedInstance.playSound(soundFileName: Sound.score.fileName)
                    
                    //run "+score" action
                    let actualScore = score * self.currentScoreMultiplier
                    let text = "+" + String(Int(actualScore))
                    let scoreText = Utilities.getNumberNode(from: text, anchor_x: true, anchor_y: true)
                    scoreText.xScale = 0.9
                    scoreText.yScale = 0.9
                    scoreText.zPosition = 9
                    scoreText.position = CGPoint(x: (position.x + self.scoreTextOffset.x), y: (position.y + self.scoreTextOffset.y))
                    Utilities.runAction_addScore(scoreText: scoreText, in: self.stageScene)
                                        
                    //update total score
                    self.currentScore += actualScore
                }
                
                //check if it's target
                if shootable is Target
                {
                    self.stageScene.updateTargetIcon()
                }
                
                //was shot
                shootable.wasShot()
            }
        ]))
                                                        
        //reload only when the magazine is completely empty
        if self.stageScene.magazine.allEmpty()
        {
            self.stageScene.gameStateMachine.enter(ReloadingState.self)
        }
    }
    
    private func findShotNode(at position: CGPoint) -> (shootable: Shootable?, shotNode: SKNode?)
    {
        var shootable: Shootable?
        var shotNode: SKNode?
        var maxZPosition: CGFloat = 0
        
        self.stageScene.physicsWorld.enumerateBodies(at: position)
        { (body, pointer) in
            
            guard var node = body.node else { return }
            var parent = SKNode()
            Utilities.getRootNode(of: &node, result: &parent)
         
            if let parentShootable = parent as? Shootable
            {
                if parent.zPosition >= maxZPosition
                {
                    maxZPosition = parent.zPosition
                    shotNode = node
                    shootable = parentShootable
                }
            }
        }
        return (shootable, shotNode)
    }
}
