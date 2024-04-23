import Foundation
import SpriteKit


class Utilities
{
    static let impactFeedbackGenerator_light = UIImpactFeedbackGenerator(style: .light)
    static let impactFeedbackGenerator_medium = UIImpactFeedbackGenerator(style: .medium)
    static let impactFeedbackGenerator_heavy = UIImpactFeedbackGenerator(style: .heavy)
    static let impactFeedbackGenerator_rigid = UIImpactFeedbackGenerator(style: .rigid)
    static let impactFeedbackGenerator_soft = UIImpactFeedbackGenerator(style: .soft)
    
    static let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    static let notificationFeedBackGenerator = UINotificationFeedbackGenerator()
    
    static func getRootNode(of node: inout SKNode, result rootNode: inout SKNode)
    {
        if let parent = node.parent
        {
            rootNode = parent
        }
        else
        {
            rootNode = node
        }        
    }
    
    static func addImageToNode(in scene: SKScene, imageNamed: String, xScale: Double = 1, yScale: Double = 1, to node: SKNode, at position: CGPoint, willDisappear: Bool = true, waitTime: Double = 1.5, fadeTime: Double = 1.5)
    {
        let convertedPosition = scene.convert(position, to: node)
        let shot = SKSpriteNode(imageNamed: imageNamed)
        
        shot.position = convertedPosition
        shot.xScale = xScale
        shot.yScale = yScale
        node.addChild(shot)
        
        if willDisappear
        {
            shot.run(.sequence([
                .wait(forDuration: waitTime),
                .fadeAlpha(to: 0, duration: fadeTime),
                .removeFromParent()
            ]))
        }
    }
    
    static func runAction_addScore(scoreText: SKNode, in scene: SKScene)
    {
        scene.addChild(scoreText)
        (scene as? StageScene)?.animatedNodes.append(scoreText)
        
        scoreText.run(.sequence([
            .scale(to: 0.5, duration: 0.2),
            .scale(to: 0.3, duration: 0.65),
            .run {
                if let stageScene = scene as? StageScene
                {
                    stageScene.animatedNodes.remove(
                        at: stageScene.animatedNodes.firstIndex(of: scoreText)!)
                }
            },
            .removeFromParent()
        ]))
        scoreText.run(.fadeOut(withDuration: 0.85))
    }
    
    static func getNumberNode(from number: String, anchor_x centeredHorizontally: Bool = false, anchor_y centeredVertically: Bool = false) -> SKNode
    {
        let numberNode = SKNode()
        var width: Double = 0
        let height: Double = 57
        
        for character in number
        {
            var characterNode = SKSpriteNode()
            characterNode.anchorPoint = CGPoint(x: 0, y: 0)
            characterNode.position = CGPoint(x: width, y: 0)
            
            if character == "0"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number0.imageName)
                characterNode.size.width = 42
                characterNode.size.height = 57
            }
            else if character == "1"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number1.imageName)
                characterNode.size.width = 30
                characterNode.size.height = 57
            }
            else if character == "2"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number2.imageName)
                characterNode.size.width = 41
                characterNode.size.height = 57
            }
            else if character == "3"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number3.imageName)
                characterNode.size.width = 40
                characterNode.size.height = 57
            }
            else if character == "4"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number4.imageName)
                characterNode.size.width = 45
                characterNode.size.height = 57
            }
            else if character == "5"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number5.imageName)
                characterNode.size.width = 41
                characterNode.size.height = 57
            }
            else if character == "6"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number6.imageName)
                characterNode.size.width = 40
                characterNode.size.height = 57
            }
            else if character == "7"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number7.imageName)
                characterNode.size.width = 41
                characterNode.size.height = 57
            }
            else if character == "8"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number8.imageName)
                characterNode.size.width = 40
                characterNode.size.height = 57
            }
            else if character == "9"
            {
                characterNode.texture = SKTexture(imageNamed: Image.number9.imageName)
                characterNode.size.width = 41
                characterNode.size.height = 57
            }
            else if character == "+"
            {
                characterNode.texture = SKTexture(imageNamed: Image.plus.imageName)
                characterNode.size.width = 40
                characterNode.size.height = 40
                characterNode.position = CGPoint(x: width, y: 8)
            }
            else if character == "*"
            {
                characterNode.texture = SKTexture(imageNamed: Image.multiply.imageName)
                characterNode.size.width = 40
                characterNode.size.height = 40
                characterNode.position = CGPoint(x: width, y: 8)
            }
            else if character == "."
            {
                characterNode.texture = SKTexture(imageNamed: Image.dot.imageName)
                characterNode.size.width = 20
                characterNode.size.height = 20
            }
            else
            {
                characterNode = SKSpriteNode()
            }
            
            numberNode.addChild(characterNode)
            width += characterNode.size.width
        }
        
        
        if centeredVertically
        {
            if centeredHorizontally
            {
                let node = SKNode()
                numberNode.position = CGPoint(x: -width / 2, y: -height / 2)
                node.addChild(numberNode)
                return node
            }
            else
            {
                let node = SKNode()
                numberNode.position = CGPoint(x: 0, y: -height / 2)
                node.addChild(numberNode)
                return node
            }
        }
        else
        {
            if centeredHorizontally
            {
                let node = SKNode()
                numberNode.position = CGPoint(x: -width / 2, y: 0)
                node.addChild(numberNode)
                return node
            }
            else
            {
                return numberNode
            }
        }
    }
    
    static func impactFeedback_light(intensity: CGFloat = 1.0)
    {
        Utilities.impactFeedbackGenerator_light.impactOccurred(intensity: intensity)
    }
    static func impactFeedback_medium(intensity: CGFloat = 1.0)
    {
        Utilities.impactFeedbackGenerator_medium.impactOccurred(intensity: intensity)
    }
    static func impactFeedback_heavy(intensity: CGFloat = 1.0)
    {
        Utilities.impactFeedbackGenerator_heavy.impactOccurred(intensity: intensity)
    }
    static func impactFeedback_rigid(intensity: CGFloat = 1.0)
    {
        Utilities.impactFeedbackGenerator_rigid.impactOccurred(intensity: intensity)
    }
    static func impactFeedback_soft(intensity: CGFloat = 1.0)
    {
        Utilities.impactFeedbackGenerator_soft.impactOccurred(intensity: intensity)
    }
    static func selectionFeedback()
    {
        Utilities.selectionFeedbackGenerator.selectionChanged()
    }
    static func notificationFeedback_success()
    {
        Utilities.notificationFeedBackGenerator.notificationOccurred(.success)
    }
    static func notificationFeedback_warning()
    {
        Utilities.notificationFeedBackGenerator.notificationOccurred(.warning)
    }
    static func notificationFeedback_error()
    {
        Utilities.notificationFeedBackGenerator.notificationOccurred(.error)
    }
}

func radian(degree: CGFloat) -> CGFloat
{
    return CGFloat.pi * degree / 180
}


enum Image: String
{
    
    case fireButtonReleased = "fire_normal"
    case fireButtonPressed = "fire_pressed"
    case fireButtonReloading = "fire_reloading"
    
    case rifle = "rifle"
    case crosshair = "crosshair"
    
    case bulletEmpty = "icon_bullet_empty"
    case bullet = "icon_bullet"
    
    case shotBlue = "shot_blue"
    case shotBrown = "shot_brown"
    
    case circleMarkHolder = "mark_circle_holder"
    case circleMark = "mark_circle"
    
    case duckIcon = "icon_duck"
    case targetIcon = "icon_target"
    case starIcon = "icon_star"
    case targetIconHolder = "icon_target_holder"
    
    case oakTree = "tree_oak"
    case pineTree = "tree_pine"
    
    case startButtonReleased = "button/start_released"
    case startButtonPressed = "button/start_pressed"
    case pauseButtonReleased = "button/pause_released"
    case pauseButtonPressed = "button/pause_pressed"
    case restartButtonReleased = "button/restart_released"
    case restartButtonPressed = "button/restart_pressed"
    case quitButtonReleased = "button/quit_released"
    case quitButtonPressed = "button/quit_pressed"
    case questionButtonReleased = "button/question_released"
    case questionButtonPressed = "button/question_pressed"
    
    case startMenu = "menu/start"
    case pauseMenu = "menu/pause"
    case quitMenu = "menu/quit"
    case ruleMenu = "menu/rule"
    
    case number0 = "number/0"
    case number1 = "number/1"
    case number2 = "number/2"
    case number3 = "number/3"
    case number4 = "number/4"
    case number5 = "number/5"
    case number6 = "number/6"
    case number7 = "number/7"
    case number8 = "number/8"
    case number9 = "number/9"
    
    case plus = "number/+"
    case multiply = "number/*"
    case dot = "number/dot"
    
    case recoreText = "text_record"
    
    case go = "go"
    
    var imageName: String
    {
        return rawValue
    }
}


enum ActionKey: String
{
    
    case reloading
    case treeShaking
    case curtainShaking
    case timerTriggerWithDelay
    case duckGeneratorTriggerWithDelay
    case targetGeneratorTriggerWithDelay
    case birdGeneratorTriggerWithDelay
    case swanGeneratorTriggerWithDelay
    
    var key: String
    {
        return rawValue
    }
}

enum Sound: String
{
    case musicLoop = "Cheerful Annoyance.wav"
    case hit = "hit.wav"
    case reload = "reload.wav"
    case score = "score.wav"
    case click = "click.wav"
    case countDown = "countDown.wav"
    case gameOver = "gameOver.wav"
    case openAndClose = "open.wav"
    case recordBreaking = "record-breaking.mp3"
    
    var fileName: String
    {
        return rawValue
    }
}


class CountDownTimer
{
    let refreshTime: Double!
    unowned var stageScene: StageScene
    var isCounting = false
    var hasStarted = false
    var timer: Timer?
    let callback: () -> ()
    var remainTime: Double!
    {
        didSet
        {
            let text = String(Int(self.remainTime))
            self.stageScene.updateCountDownText(countDownNumber: text)
        }
    }
    
    init(refreshTime: Double, signal: @escaping () -> Void, scene: StageScene)
    {
        self.callback = signal
        self.refreshTime = refreshTime
        self.stageScene = scene
    }
    
    func start(totalTime: Double, delay: Double = 0)
    {
        if !self.hasStarted
        {
            self.remainTime = totalTime
            self.hasStarted = true
            self.isCounting = false
            self.timer = Timer.scheduledTimer(withTimeInterval: self.refreshTime, repeats: true, block: self.countDown(timer:))
            
            self.stageScene.removeAction(forKey: ActionKey.timerTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isCounting = true
                }
            ]), withKey: ActionKey.timerTriggerWithDelay.key)
        }
    }
    
    func restart(totalTime: Double, delay: Double = 0)
    {
        if self.hasStarted
        {
            self.isCounting = false
            self.remainTime = totalTime
            
            self.stageScene.removeAction(forKey: ActionKey.timerTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isCounting = true
                }
            ]), withKey: ActionKey.timerTriggerWithDelay.key)
        }
    }
    
    func pause()
    {
        if self.hasStarted
        {
            self.isCounting = false
        }
    }
    
    func resume()
    {
        if self.hasStarted
        {
            self.isCounting = true
        }
    }
    
    func expire()
    {
        if self.hasStarted
        {
            self.timer?.invalidate()
            self.isCounting = false
            self.hasStarted = false
        }
    }
    
    private func countDown(timer: Timer)
    {
        if self.isCounting
        {
            self.remainTime -= self.refreshTime
            Audio.sharedInstance.playSound(soundFileName: Sound.countDown.fileName)
            Audio.sharedInstance.player(with: Sound.countDown.fileName)?.volume = 0.5
        }
        if self.remainTime <= 0
        {
            self.isCounting = false
            self.callback()
        }
    }
}
