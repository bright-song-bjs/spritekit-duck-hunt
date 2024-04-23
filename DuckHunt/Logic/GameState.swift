import Foundation
import GameplayKit


class GameState: GKState
{
    unowned var stageScene: StageScene
    unowned var spriteGenerator: SpriteGenerator
    unowned var fireButton: FireButton
    unowned var magazine: Magazine
    unowned var shooting: Shooting
    
    init(stageScene: StageScene)
    {
        self.stageScene = stageScene
        self.spriteGenerator = stageScene.spriteGenerator
        self.fireButton = stageScene.fireButton
        self.magazine = stageScene.magazine
        self.shooting = stageScene.shooting
        
        super.init()
    }
}


//MARK: - Starting State
class StartingState: GameState
{
    override func didEnter(from previousState: GKState?)
    {
        self.stageScene.showStartUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.musicLoop.fileName)
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.3
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.numberOfLoops = -1
        
        self.magazine.reload()
    }
    
    override func willExit(to nextState: GKState)
    {
        self.stageScene.hideStartUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.openAndClose.fileName)
        Audio.sharedInstance.player(with: Sound.openAndClose.fileName)?.volume = 1.5
        
        //3-2-1-go
        self.stageScene.removeAnimatedNodes()
        self.stageScene.runAction_321Go()
        
        //timer and generator
        self.spriteGenerator.startAllGenerator(delay: 3)
        self.stageScene.countDownTimer.start(totalTime: self.stageScene.totalTime, delay: 3)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass is ShootingState.Type && self.magazine.allFull()
    }
}


//MARK: - Restarting State
class RestartingState: GameState
{
    override func didEnter(from previousState: GKState?)
    {
        if previousState is EndingState
        {
            Audio.sharedInstance.playSound(soundFileName: Sound.musicLoop.fileName)
            Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.3
            Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.numberOfLoops = -1
        }
        
        //clear ducks and targets and birds
        self.spriteGenerator.destroyAllGenerated()
        
        //restore scene
        Tree.restoreAllTrees()
        self.stageScene.crosshair.position = CGPoint(x: (self.stageScene.scene?.frame.midX ?? 406), y: (self.stageScene.scene?.frame.midY ?? 200))
        self.stageScene.crosshairPosition = nil
        
        //clear score
        self.stageScene.shooting.currentScore = 0
        
        //clear target icon and reset multiplier
        self.shooting.targetCount = 0
        self.shooting.currentScoreMultiplier = 1
        for each in self.stageScene.targetIcon
        {
            if each.parent != nil
            {
                each.removeAllActions()
                each.alpha = 0
            }
        }
        
        //reload magazine
        self.magazine.reload()
        
        //enter shooting state
        self.stateMachine?.enter(ShootingState.self)
    }
    
    override func willExit(to nextState: GKState)
    {
        //remove current animation and start 3-2-1-go
        self.stageScene.removeAnimatedNodes()
        self.stageScene.runAction_321Go()
        
        //timer and generator
        self.spriteGenerator.restartAllGenerator(delay: 3)
        self.stageScene.countDownTimer.restart(totalTime: self.stageScene.totalTime, delay: 3)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass is ShootingState.Type && self.magazine.allFull()
    }
}


//MARK: - Shooting State
class ShootingState: GameState
{
    override func didEnter(from previousState: GKState?)
    {
        self.stageScene.showShootingUI()
        self.stageScene.crosshairMovingEnabled = true
    }
    
    override func willExit(to nextState: GKState)
    {
        if !(nextState is ReloadingState)
        {
            self.stageScene.hideShootingUI()
            self.stageScene.crosshairMovingEnabled = false
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass is ReloadingState.Type || stateClass is PauseState.Type || stateClass is EndingState.Type
    }
}


//MARK: - Reloading State
class ReloadingState: GameState
{
    override func didEnter(from previousState: GKState?)
    {
        if previousState is PauseState
        {
            self.stageScene.showShootingUI()
        }
        
        self.fireButton.isReloading = true
        
        self.fireButton.removeAction(forKey: ActionKey.reloading.key)
        self.fireButton.run(.sequence([
            .run
            {
                self.fireButton.texture = SKTexture(imageNamed: Image.fireButtonReloading.imageName)
            },
            .rotate(byAngle: 360, duration: 30)
        ]), withKey: ActionKey.reloading.key)
        
        
        var count: Double = -1
        for (i, bullet) in self.magazine.bullets.enumerated()
        {
            if !bullet.hasBullet
            {
                count += 1
                bullet.run(.sequence([
                    .wait(forDuration: self.magazine.singleReloadingTime * count),
                    .run
                    {
                        //audio
                        Audio.sharedInstance.playSound(soundFileName: Sound.reload.fileName)
                        Audio.sharedInstance.player(with: Sound.reload.fileName)?.volume = 0.3
                        
                        //haptic
                        Utilities.impactFeedback_light()
                        
                        bullet.hasBullet = true
                        
                        //check if reloading finished
                        if i == self.magazine.capacity - 1
                        {
                            self.stateMachine?.enter(ShootingState.self)
                        }
                    }
                ]))
            }
            
        }
    }
    
    override func willExit(to nextState: GKState)
    {
        if nextState is PauseState
        {
            for bullet in self.magazine.bullets
            {
                bullet.removeAllActions()
            }
            self.stageScene.hideShootingUI()
        }
        else
        {
            self.fireButton.isReloading = false
            
            self.fireButton.removeAction(forKey: ActionKey.reloading.key)
            self.fireButton.texture = SKTexture(imageNamed: Image.fireButtonReleased.imageName)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return (stateClass is ShootingState.Type && self.magazine.allFull()) || stateClass is PauseState.Type || stateClass is EndingState.Type || stateClass is RestartingState.Type
    }
}


//MARK: - Ending State
class EndingState: GameState
{
    var finalScore: SKNode!
    var recordText: SKSpriteNode!
    var recordNumber: SKNode!
    override func didEnter(from previousState: GKState?)
    {
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.stop()
        self.stageScene.showQuitUI()
        self.stageScene.hideShootingUI()
        self.stageScene.hideHeadsUpUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.openAndClose.fileName)
        Audio.sharedInstance.player(with: Sound.openAndClose.fileName)?.volume = 1.5
        
        //remove animated nodes
        self.stageScene.removeAnimatedNodes()
        
        //destroy generated sprites
        self.spriteGenerator.destroyAllGenerated(withAnimation: true)
        
        //update record score and save it
        if self.stageScene.shooting.currentScore > self.stageScene.shooting.recordScore
        {
            self.stageScene.shooting.recordScore = self.stageScene.shooting.currentScore
            Audio.sharedInstance.playSound(soundFileName: Sound.recordBreaking.fileName)
            Audio.sharedInstance.player(with: Sound.recordBreaking.fileName)?.volume = 1.8
        }
        else
        {
            Audio.sharedInstance.playSound(soundFileName: Sound.gameOver.fileName)
            Audio.sharedInstance.player(with: Sound.gameOver.fileName)?.volume = 1.8
        }
        
        UserDefaults.standard.set(self.stageScene.shooting.recordScore, forKey: "RecordScore")
        
        //final score
        let finalScoreText = String(Int(self.stageScene.shooting.currentScore))
        self.finalScore = Utilities.getNumberNode(from: finalScoreText, anchor_x: true, anchor_y: true)
        self.finalScore.zPosition = 11.5
        self.finalScore.position = CGPoint(x: (self.stageScene.scene?.frame.midX ?? 406), y: 195)
        self.stageScene.scene?.addChild(self.finalScore)
        
        //record text
        self.recordText = SKSpriteNode(imageNamed: Image.recoreText.imageName)
        self.recordText.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.recordText.zPosition = 11.5
        self.recordText.position = CGPoint(x: 492, y: 146)
        self.recordText.size.width = 57
        self.recordText.size.height = 17
        self.stageScene.scene?.addChild(self.recordText)
        
        //record number
        let recordScoreText = String(Int(self.stageScene.shooting.recordScore))
        self.recordNumber = Utilities.getNumberNode(from: recordScoreText, anchor_x: true, anchor_y: true)
        self.recordNumber.zPosition = 11.5
        self.recordNumber.position = CGPoint(x: 492, y: 128)
        self.recordNumber.xScale = 0.2982
        self.recordNumber.yScale = 0.2982
        self.stageScene.scene?.addChild(self.recordNumber)
        
        //pause the generated (don't pause the scene)
        self.spriteGenerator.pauseAllGenerator()
    }
    
    override func willExit(to nextState: GKState)
    {
        self.stageScene.hideQuitUI()
        self.stageScene.showHeadsUpUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.openAndClose.fileName)
        Audio.sharedInstance.player(with: Sound.openAndClose.fileName)?.volume = 1.5
        
        self.finalScore.removeFromParent()
        self.recordText.removeFromParent()
        self.recordNumber.removeFromParent()
        
        self.stageScene.isPaused = false
        self.spriteGenerator.restartAllGenerator(delay: 3)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass is RestartingState.Type
    }
}


//MARK: - Pause State
class PauseState: GameState
{
    var isFromReloadingState = false
    
    override func didEnter(from previousState: GKState?)
    {
        if previousState is ReloadingState
        {
            self.isFromReloadingState = true
        }
        
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.1
        self.stageScene.showPauseUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.openAndClose.fileName)
        Audio.sharedInstance.player(with: Sound.openAndClose.fileName)?.volume = 1.5
        self.stageScene.isPaused = true
        
        //remove animated
        self.stageScene.removeAnimatedNodes()
        
        //timer and generator
        self.spriteGenerator.pauseAllGenerator()
        self.stageScene.countDownTimer.pause()
    }
    
    override func willExit(to nextState: GKState)
    {
        self.stageScene.hidePauseUI()
        Audio.sharedInstance.playSound(soundFileName: Sound.openAndClose.fileName)
        Audio.sharedInstance.player(with: Sound.openAndClose.fileName)?.volume = 1.5
        self.stageScene.isPaused = false
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.3
        
        if self.isFromReloadingState && (nextState is RestartingState)
        {
            self.isFromReloadingState = false
            
            self.fireButton.isReloading = false
            self.fireButton.removeAction(forKey: ActionKey.reloading.key)
            self.fireButton.texture = SKTexture(imageNamed: Image.fireButtonReleased.imageName)
        }
                
        if !(nextState is RestartingState)
        {
            self.spriteGenerator.continueAllGenerator()
            self.stageScene.countDownTimer.resume()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass is ShootingState.Type || stateClass is ReloadingState.Type || stateClass is RestartingState.Type
    }
}
