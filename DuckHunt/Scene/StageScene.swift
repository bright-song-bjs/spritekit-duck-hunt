import Foundation
import SpriteKit
import GameplayKit


class StageScene: SKScene
{
    //MARK: - Values

    //rifle
    let rifleOffsetToCrosshair: CGFloat = 100
    
    //fireButton
    let fireButtonPosition = CGPoint(x: 100, y: 75)
    
    //magazine
    let magazinePosition = CGPoint(x: 796, y: 20)
    let bulletSpacing: Double = 21
    let bulletQuantity: Int = 7
    let reloadingTime: Double = 1.5
    
    //score and targetIcon
    let starIconWidth: Double = 36.5
    let starIconHeight: Double = 36.5
    let scoreTextPosition = CGPoint(x: 32, y: 373)
    let targetIconPsition = CGPoint(x: 780, y: 373)
    let scoreTextHeight: Double = 35
    let targetIconHeight: Double = 35
    let scoreIconSpacing: Double = 25
    let targetIconSpacing: Double = 40
    
    //timer and pauseButton
    let countDownTextPosition = CGPoint(x: 406, y: 373)
    let countDownTextHeight: Double = 35
    let pauseButtonPosition = CGPoint(x: 32, y: 325)
    
    //"3-2-1-Go"Action
    let numberWidth: Double = 100
    let numberHeight: Double = 150
    let goWidth: Double = 225
    let goHeight: Double = 150
    
    //other settings
    let totalTime: Double = 180
    

    

    //nodes reference
    var rifle: SKSpriteNode!
    var crosshair: SKSpriteNode!
    var fireButton: FireButton!
    var magazine: Magazine!
    var startButton: StartButton!
    var restartButton: RestartButton!
    var pauseButton: PauseButton!
    var questionButton: QuestionButton!
    var quitButton: QuitButton!
    
    //touches
    var touchOffset: (x: CGFloat, y: CGFloat)?
    var selectedNodes: [UITouch : SKNode] = [:]
    
    //crosshair
    var crosshairMovingEnabled: Bool = false
    var crosshairPosition: CGPoint?
    
    //game logic
    var gameStateMachine: GKStateMachine!
    var spriteGenerator: SpriteGenerator!
    var shooting: Shooting!
    
    //timer
    var countDownTimer: CountDownTimer!
    var countDownText = SKNode()
    
    //icon
    var starIcon: SKSpriteNode!
    var scoreText = SKNode()
    var targetIconHolder = Array<SKSpriteNode>()
    var targetIcon = Array<SKSpriteNode>()
    
    //animation
    var animatedNodes = Array<SKNode>()  //"3-2-1-Go" nodes and "+20" nodes
    
    //menu
    var startMenu: SKSpriteNode!
    var pauseMenu: SKSpriteNode!
    var quitMenu: SKSpriteNode!
    var ruleMenu: SKSpriteNode!
    var line1_label: SKLabelNode!
    var line2_label: SKLabelNode!
    var line3_label: SKLabelNode!
    var line4_label: SKLabelNode!
    var line5_label: SKLabelNode!
    var line6_label: SKLabelNode!
}


extension StageScene
{
    override func didMove(to view: SKView)
    {
        Shared.sharedInstance.registerScene(self)
        
        self.setUpReference()
        self.setUpNodes()
        
        gameStateMachine.enter(StartingState.self)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        self.syncRiflePosition()
        self.setBoundry()
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if let fireButton = node as? FireButton
            {
                //check and make sure it's not reloading
                if !fireButton.isReloading
                {
                    self.selectedNodes[touch] = fireButton
                    fireButton.isPressed = true
                    self.shooting.shoot()
                }
            }
            else if let button = node as? Button
            {
                self.selectedNodes[touch] = button
                button.isPressed = true
                Utilities.impactFeedback_light()
                Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
            }
            else
            {
                if !self.selectedNodes.values.contains(self.crosshair) && self.crosshairMovingEnabled
                {
                    self.selectedNodes[touch] = self.crosshair
                    let xOffset = location.x - self.crosshair.position.x
                    let yOffset = location.y - self.crosshair.position.y
                    self.touchOffset = (xOffset, yOffset)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touchOffset = self.touchOffset else { return }
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let current = self.atPoint(location)
            
            if let node = self.selectedNodes[touch]
            {
                if (node is Crosshair) && self.crosshairMovingEnabled
                {
                    let crosshairPosition = CGPoint(
                        x: location.x - touchOffset.x, y: location.y - touchOffset.y)
                    self.crosshairPosition = crosshairPosition
                    self.crosshair.position = crosshairPosition
                }
                else if let button = node as? Button
                {
                    if current != node
                    {
                        button.isPressed = false
                        Utilities.impactFeedback_light(intensity: 0.7)
                        Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                        Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                        self.selectedNodes.removeValue(forKey: touch)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            if let node = self.selectedNodes[touch]
            {
                if let fireButton = node as? FireButton
                {
                    if !fireButton.isReloading
                    {
                        fireButton.isPressed = false
                    }
                }
                else if let startButton = node as? StartButton
                {
                    startButton.isPressed = false
                    Utilities.impactFeedback_light(intensity: 0.7)
                    Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                    Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                    
                    //enter game state
                    if self.fireButton.isReloading
                    {
                        self.gameStateMachine.enter(ReloadingState.self)
                    }
                    else
                    {
                        self.gameStateMachine.enter(ShootingState.self)
                    }
                }
                else if let restartButton = node as? RestartButton
                {
                    restartButton.isPressed = false
                    Utilities.impactFeedback_light(intensity: 0.7)
                    Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                    Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                    
                    //enter restarting state
                    self.gameStateMachine.enter(RestartingState.self)
                }
                else if let questionButton = node as? QuestionButton
                {
                    questionButton.isPressed = false
                    Utilities.impactFeedback_light(intensity: 0.7)
                    Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                    Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                    
                    //pop up rule menu
                    self.hideHeadsUpUI()
                    self.hideStartUI()
                    self.showRuleUI()
                }
                else if let quitButton = node as? QuitButton
                {
                    quitButton.isPressed = false
                    Utilities.impactFeedback_light(intensity: 0.7)
                    Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                    Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                    
                    //close rule menu
                    self.hideRuleUI()
                    self.showStartUI()
                    self.showHeadsUpUI()
                }
                else if let pauseButton = node as? PauseButton
                {
                    pauseButton.isPressed = false
                    Utilities.impactFeedback_light(intensity: 0.7)
                    Audio.sharedInstance.playSound(soundFileName: Sound.click.fileName)
                    Audio.sharedInstance.player(with: Sound.click.fileName)?.volume = 0.35
                    
                    //enter pause state
                    self.gameStateMachine.enter(PauseState.self)
                }
                
                self.selectedNodes.removeValue(forKey: touch)
            }
        }
    }
}


extension StageScene
{
    //MARK: - Reference and Nodes
    private func setUpReference()
    {
        self.rifle = Rifle()
        self.crosshair = Crosshair()
        self.fireButton = FireButton()
        self.startButton = StartButton()
        self.restartButton = RestartButton()
        self.pauseButton = PauseButton()
        self.questionButton = QuestionButton()
        self.quitButton = QuitButton()
        self.startMenu = SKSpriteNode(imageNamed: Image.startMenu.imageName)
        self.pauseMenu = SKSpriteNode(imageNamed: Image.pauseMenu.imageName)
        self.quitMenu = SKSpriteNode(imageNamed: Image.quitMenu.imageName)
        self.ruleMenu = SKSpriteNode(imageNamed: Image.ruleMenu.imageName)
        self.line1_label = SKLabelNode()
        self.line2_label = SKLabelNode()
        self.line3_label = SKLabelNode()
        self.line4_label = SKLabelNode()
        self.line5_label = SKLabelNode()
        self.line6_label = SKLabelNode()
        
        self.magazine = Magazine(capacity: self.bulletQuantity, reloadingTime: self.reloadingTime, spacing: self.bulletSpacing)
        self.countDownTimer = CountDownTimer(refreshTime: 1, signal: self.endGame, scene: self)
        self.spriteGenerator = SpriteGenerator(stageScene: self)
        self.shooting = Shooting(stageScene: self)
        
        self.gameStateMachine = GKStateMachine(states: [
            StartingState(stageScene: self),
            RestartingState(stageScene: self),
            ShootingState(stageScene: self),
            ReloadingState(stageScene: self),
            EndingState(stageScene: self),
            PauseState(stageScene: self)
        ])   
    }
    
    private func setUpNodes()
    {
        //crosshair
        self.crosshair.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        self.crosshair.zPosition = 9.5
        self.crosshair.xScale = 0.7
        self.crosshair.yScale = 0.7
        
        //rifle
        self.rifle.position.y = -12.6
        self.rifle.zPosition = 10
        
        //fireButton
        self.fireButton.position = self.fireButtonPosition
        self.fireButton.zPosition = 11
        
        //magazine
        self.magazine.position = self.magazinePosition
        self.magazine.zPosition = 11
        
        //buttons
        self.pauseButton.position = self.pauseButtonPosition
        self.pauseButton.zPosition = 11.5
        self.startButton.zPosition = 11.5
        self.restartButton.zPosition = 11.5
        self.questionButton.zPosition = 11.5
        self.quitButton.position = CGPoint(x: 91, y: 324)
        self.quitButton.zPosition = 11.6
        
        //start menu
        self.startMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.startMenu.zPosition = 11.4
        self.startMenu.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        self.startMenu.size.width = 323
        self.startMenu.size.height = 225
        
        //pause menu
        self.pauseMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.pauseMenu.zPosition = 11.4
        self.pauseMenu.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        self.pauseMenu.size.width = 323
        self.pauseMenu.size.height = 225
        
        //quit menu
        self.quitMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.quitMenu.zPosition = 11.4
        self.quitMenu.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        self.quitMenu.size.width = 323
        self.quitMenu.size.height = 305
        
        
        //score - starIcon
        self.starIcon = SKSpriteNode(imageNamed: Image.starIcon.imageName)
        self.starIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.starIcon.zPosition = 12
        self.starIcon.position = self.scoreTextPosition
        self.starIcon.size.width = self.starIconWidth
        self.starIcon.size.height = self.starIconHeight
        self.addChild(starIcon)
        
        //score - targetIcon and targetIconHolder
        for i in 0...(shooting.targetThreshold - 1)
        {
            //targetIconHolder
            let targetIconHolder = SKSpriteNode(imageNamed: Image.targetIconHolder.imageName)
            targetIconHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            targetIconHolder.zPosition = 12
            targetIconHolder.position = CGPoint(x: (self.targetIconPsition.x - Double(i) * self.targetIconSpacing), y: self.targetIconPsition.y)
            targetIconHolder.size.width = self.targetIconHeight
            targetIconHolder.size.height = self.targetIconHeight
            self.targetIconHolder.append(targetIconHolder)
            self.addChild(targetIconHolder)
            
            //targetIcon
            let targetIcon = SKSpriteNode(imageNamed: Image.targetIcon.imageName)
            targetIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            targetIcon.zPosition = 12
            targetIcon.position = CGPoint(x: (self.targetIconPsition.x - Double(i) * self.targetIconSpacing), y: self.targetIconPsition.y)
            let desiredHeight = 0.8285 * self.targetIconHeight
            targetIcon.size.width = desiredHeight
            targetIcon.size.height = desiredHeight
            self.targetIcon.append(targetIcon)
            
            targetIcon.alpha = 0
            self.addChild(targetIcon)
        }
        
        //rule menu
        self.ruleMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.ruleMenu.zPosition = 11.4
        self.ruleMenu.position = CGPoint(x: 406, y: 202)
        self.ruleMenu.size.width = 650
        self.ruleMenu.size.height = 364
        
        //rules - line1
        self.line1_label.text = "· 击中      和      可获得相应"
        self.line1_label.fontColor = SKColor.brown
        self.line1_label.fontSize = 24
        self.line1_label.horizontalAlignmentMode = .left
        self.line1_label.verticalAlignmentMode = .center
        self.line1_label.fontName = "PFanHuTuTi"
        self.line1_label.position = CGPoint(x: 150, y: 247)
        self.line1_label.zPosition = 11.5
        
        let line1_star = SKSpriteNode(imageNamed: Image.starIcon.imageName)
        line1_star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line1_star.position = CGPoint(x: 294.5, y: 0)
        line1_star.zPosition = 0
        line1_star.size.width = 25
        line1_star.size.height = 25
        line1_star.name = "star"
        line1_label.addChild(line1_star)
        
        let line1_duck = SKSpriteNode(imageNamed: Image.duckIcon.imageName)
        line1_duck.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line1_duck.position = CGPoint(x: 143.5, y: 0)
        line1_duck.zPosition = 0
        line1_duck.size.width = 25
        line1_duck.size.height = 25
        line1_duck.name = "duck"
        line1_label.addChild(line1_duck)
        
        let line1_bird = SKSpriteNode(imageNamed: "bird/1")
        line1_bird.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line1_bird.position = CGPoint(x: 81.5, y: 0)
        line1_bird.zPosition = 0
        line1_bird.size.width = 25
        line1_bird.size.height = 25
        line1_bird.xScale = -1
        line1_bird.name = "bird"
        line1_label.addChild(line1_bird)
        
        //rules - line2
        self.line2_label.text = "· 击中5个      可使      和      的      提高"
        self.line2_label.fontColor = SKColor.brown
        self.line2_label.fontSize = 24
        self.line2_label.horizontalAlignmentMode = .left
        self.line2_label.verticalAlignmentMode = .center
        self.line2_label.fontName = "PFanHuTuTi"
        self.line2_label.position = CGPoint(x: 150, y: 203)
        self.line2_label.zPosition = 11.5
        
        let line2_star = SKSpriteNode(imageNamed: Image.starIcon.imageName)
        line2_star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line2_star.position = CGPoint(x: 323.5, y: 0)
        line2_star.zPosition = 0
        line2_star.size.width = 25
        line2_star.size.height = 25
        line2_star.name = "star"
        line2_label.addChild(line2_star)
        
        let line2_duck = SKSpriteNode(imageNamed: Image.duckIcon.imageName)
        line2_duck.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line2_duck.position = CGPoint(x: 265, y: 0)
        line2_duck.zPosition = 0
        line2_duck.size.width = 25
        line2_duck.size.height = 25
        line2_duck.name = "duck"
        line2_label.addChild(line2_duck)
        
        let line2_target = SKSpriteNode(imageNamed: Image.targetIcon.imageName)
        line2_target.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line2_target.position = CGPoint(x: 119.5, y: 0)
        line2_target.zPosition = 0
        line2_target.size.width = 25
        line2_target.size.height = 25
        line2_target.name = "target"
        line2_label.addChild(line2_target)
        
        let line2_bird = SKSpriteNode(imageNamed: "bird/1")
        line2_bird.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line2_bird.position = CGPoint(x: 204, y: 0)
        line2_bird.zPosition = 0
        line2_bird.size.width = 25
        line2_bird.size.height = 25
        line2_bird.xScale = -1
        line2_bird.name = "bird"
        line2_label.addChild(line2_bird)
        
        //rules - line3
        self.line3_label.text = "·       藏在树林中，可先将      击倒"
        self.line3_label.fontColor = SKColor.brown
        self.line3_label.fontSize = 24
        self.line3_label.horizontalAlignmentMode = .left
        self.line3_label.verticalAlignmentMode = .center
        self.line3_label.fontName = "PFanHuTuTi"
        self.line3_label.position = CGPoint(x: 150, y: 159)
        self.line3_label.zPosition = 11.5
        
        let line3_tree = SKSpriteNode(imageNamed: Image.pineTree.imageName)
        line3_tree.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line3_tree.position = CGPoint(x: 286, y: 1)
        line3_tree.zPosition = 0
        line3_tree.size.width = 22
        line3_tree.size.height = 30
        line3_tree.name = "tree"
        line3_label.addChild(line3_tree)
        
        let line3_target = SKSpriteNode(imageNamed: Image.targetIcon.imageName)
        line3_target.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line3_target.position = CGPoint(x: 30, y: 0)
        line3_target.zPosition = 0
        line3_target.size.width = 25
        line3_target.size.height = 25
        line3_target.name = "target"
        line3_label.addChild(line3_target)
        
        //rules - line4
        self.line4_label.text = "· 击中      可清除所有      和      ，并获得相应的"
        self.line4_label.fontColor = SKColor.brown
        self.line4_label.fontSize = 24
        self.line4_label.horizontalAlignmentMode = .left
        self.line4_label.verticalAlignmentMode = .center
        self.line4_label.fontName = "PFanHuTuTi"
        self.line4_label.position = CGPoint(x: 150, y: 115)
        self.line4_label.zPosition = 11.5
        
        let line4_star = SKSpriteNode(imageNamed: Image.starIcon.imageName)
        line4_star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line4_star.position = CGPoint(x: 500, y: 0)
        line4_star.zPosition = 0
        line4_star.size.width = 25
        line4_star.size.height = 25
        line4_star.name = "star"
        line4_label.addChild(line4_star)
        
        let line4_duck = SKSpriteNode(imageNamed: Image.duckIcon.imageName)
        line4_duck.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line4_duck.position = CGPoint(x: 300, y: 0)
        line4_duck.zPosition = 0
        line4_duck.size.width = 25
        line4_duck.size.height = 25
        line4_duck.name = "duck"
        line4_label.addChild(line4_duck)
        
        let line4_swan = SKSpriteNode(imageNamed: "swan/blue_2")
        line4_swan.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line4_swan.position = CGPoint(x: 84, y: 0)
        line4_swan.zPosition = 0
        line4_swan.size.width = 30
        line4_swan.size.height = 28
        line4_swan.name = "swan"
        line4_label.addChild(line4_swan)
        
        let line4_bird = SKSpriteNode(imageNamed: "bird/1")
        line4_bird.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line4_bird.position = CGPoint(x: 237.5, y: 0)
        line4_bird.zPosition = 0
        line4_bird.size.width = 25
        line4_bird.size.height = 25
        line4_bird.xScale = -1
        line4_bird.name = "bird"
        line4_label.addChild(line4_bird)
        
        //rules - line5
        self.line5_label.text = "DUCK HUNT  by 宋柏君"
        self.line5_label.fontColor = SKColor.brown
        self.line5_label.fontSize = 18
        self.line5_label.horizontalAlignmentMode = .center
        self.line5_label.verticalAlignmentMode = .center
        self.line5_label.fontName = "PFanHuTuTi"
        self.line5_label.position = CGPoint(x: 402, y: 282)
        self.line5_label.zPosition = 11.5
        
        //rules - line6
        self.line6_label.text = "每轮限时\(Int(self.totalTime))秒，快来挑战吧"
        self.line6_label.fontColor = SKColor.brown
        self.line6_label.fontSize = 18
        self.line6_label.horizontalAlignmentMode = .center
        self.line6_label.verticalAlignmentMode = .center
        self.line6_label.fontName = "PFanHuTuTi"
        self.line6_label.position = CGPoint(x: 406, y: 74)
        self.line6_label.zPosition = 11.5
    }
    
    private func syncRiflePosition()
    {
        if let position = self.crosshairPosition
        {
            self.rifle.position.x = position.x + self.rifleOffsetToCrosshair
        }
        else
        {
            self.rifle.position.x = self.crosshair.position.x + self.rifleOffsetToCrosshair
        }
    }
    
    private func setBoundry()
    {
        guard let scene = self.scene else { return }
        
        if self.rifle.position.x < scene.frame.minX
        {
            self.rifle.position.x = scene.frame.minX
        }
        if self.rifle.position.x > scene.frame.maxX
        {
            self.rifle.position.x = scene.frame.maxX
        }
        
        if self.crosshair.position.x < scene.frame.minX
        {
            self.crosshair.position.x = scene.frame.minX
        }
        if self.crosshair.position.x > scene.frame.maxX
        {
            self.crosshair.position.x = scene.frame.maxX
        }
        if self.crosshair.position.y < scene.frame.minY
        {
            self.crosshair.position.y = scene.frame.minY
        }
        if self.crosshair.position.y > scene.frame.maxY
        {
            self.crosshair.position.y = scene.frame.maxY
        }
    }
    
    //MARK: - Update HeadsUp UI
    func updateScoreText(score: String)
    {
        if self.scoreText.parent != nil
        {
            self.scoreText.removeFromParent()
        }
        
        self.scoreText = Utilities.getNumberNode(from: score, anchor_x: false, anchor_y: true)
        self.scoreText.zPosition = 12
        self.scoreText.position = CGPoint(x: (self.scoreTextPosition.x + self.scoreIconSpacing), y: self.scoreTextPosition.y)
        
        let desiredScale: Double = self.scoreTextHeight / 57
        self.scoreText.xScale = desiredScale
        self.scoreText.yScale = desiredScale
        
        self.addChild(self.scoreText)
    }
    
    func updateCountDownText(countDownNumber: String)
    {
        if self.countDownText.parent != nil
        {
            self.countDownText.removeFromParent()
        }
        self.countDownText = Utilities.getNumberNode(from: countDownNumber, anchor_x: true, anchor_y: true)
        self.countDownText.zPosition = 12
        self.countDownText.position = self.countDownTextPosition
        
        let desiredScale: Double = self.countDownTextHeight / 57
        self.countDownText.xScale = desiredScale
        self.countDownText.yScale = desiredScale
        
        self.addChild(self.countDownText)
    }
    
    func updateTargetIcon()
    {
        self.shooting.targetCount += 1
        
        if self.shooting.targetCount == self.shooting.targetThreshold
        {
            let index = self.shooting.targetCount - 1
            self.targetIcon[index].xScale = 0
            self.targetIcon[index].yScale = 0
            self.targetIcon[index].alpha = 1
            self.targetIcon[index].run(.sequence([
                .scale(to: 1.2, duration: 0.3),
                .scale(to: 1, duration: 0.2)
            ]))
            
            let popDuration = 1 / Double(self.shooting.targetThreshold)
            for i in 0...index
            {
                self.targetIcon[i].run(.sequence([
                    .wait(forDuration: (0.5 + Double(i) * popDuration)),
                    .scale(to: 1.4, duration: 0.15),
                    .run
                    {
                        Utilities.selectionFeedback()
                    },
                    .scale(to: 1, duration: 0.15)
                ]))
                self.targetIcon[i].run(.sequence([
                    .wait(forDuration: 1.5),
                    .scale(to: 2.5, duration: 0.3)
                ]))
                self.targetIcon[i].run(.sequence([
                    .wait(forDuration: 1.5),
                    .fadeOut(withDuration: 0.3),
                ]))
            }
            
            self.shooting.targetCount = 0
            
            self.shooting.currentScoreMultiplier += self.shooting.scoreMultiplier
            let text = "*" + String(format: "%.1f", self.shooting.currentScoreMultiplier)
            let node = Utilities.getNumberNode(from: text, anchor_x: true, anchor_y: true)
            node.xScale = 2.5
            node.yScale = 2.5
            node.zPosition = 9
            node.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
            node.alpha = 0
            
            self.addChild(node)
            
            node.run(.sequence([
                .wait(forDuration: 1.5),
                .run
                {
                    node.alpha = 1
                },
                .scale(to: 1.8, duration: 0.2),
                .scale(to: 0.5, duration: 0.9)
            ]))
            node.run(.sequence([
                .wait(forDuration: 1.5),
                .fadeOut(withDuration: 1.1),
                .removeFromParent()
            ]))
        }
        else
        {
            let index = self.shooting.targetCount - 1
            self.targetIcon[index].xScale = 0
            self.targetIcon[index].yScale = 0
            self.targetIcon[index].alpha = 1
            self.targetIcon[index].run(.sequence([
                .scale(to: 1.2, duration: 0.3),
                .scale(to: 1, duration: 0.2)
            ]))
        }
    }
    
    //MARK: - Show and Hide UI
    func showShootingUI()
    {
        if self.crosshair.parent == nil
        {
            self.addChild(self.crosshair)
        }
        if self.rifle.parent == nil
        {
            self.addChild(self.rifle)
        }
        if self.fireButton.parent == nil
        {
            self.addChild(self.fireButton)
        }
        if self.magazine.parent == nil
        {
            self.addChild(self.magazine)
        }
        if self.pauseButton.parent == nil
        {
            self.addChild(self.pauseButton)
        }
    }
    
    func showStartUI()
    {
        self.startButton.position = CGPoint(x: 354, y: 176)
        self.questionButton.position = CGPoint(x: 458, y: 176)
        if self.startMenu.parent == nil
        {
            self.addChild(self.startMenu)
        }
        if self.startButton.parent == nil
        {
            self.addChild(self.startButton)
        }
        if self.questionButton.parent == nil
        {
            self.addChild(self.questionButton)
        }
    }
    
    func showPauseUI()
    {
        self.startButton.position = CGPoint(x: 354, y: 176)
        self.restartButton.position = CGPoint(x: 458, y: 176)
        if self.pauseMenu.parent == nil
        {
            self.addChild(self.pauseMenu)
        }
        if self.startButton.parent == nil
        {
            self.addChild(self.startButton)
        }
        if self.restartButton.parent == nil
        {
            self.addChild(self.restartButton)
        }
    }
    
    func showQuitUI()
    {
        self.restartButton.position = CGPoint(x: 406, y: 118)
        if self.quitMenu.parent == nil
        {
            self.addChild(self.quitMenu)
        }
        if self.restartButton.parent == nil
        {
            self.addChild(self.restartButton)
        }
    }
    
    func showRuleUI()
    {
        if self.ruleMenu.parent == nil
        {
            self.addChild(self.ruleMenu)
        }
        if self.line1_label.parent == nil
        {
            self.addChild(self.line1_label)
            self.line1_label.childNode(withName: "duck")?.run(.repeatForever(.sequence([
                .wait(forDuration: 0.4),
                .moveBy(x: 0, y: 5, duration: 0.3),
                .moveBy(x: 0, y: -5, duration: 0.3)
            ])))
            self.line1_label.childNode(withName: "star")?.run(.repeatForever(.sequence([
                .scale(to: 1.2, duration: 0.4),
                .scale(to: 0.8, duration: 0.4)
            ])))
            self.line1_label.childNode(withName: "bird")?.run(.repeatForever(.sequence([
                .wait(forDuration: 1),
                .moveBy(x: 0, y: 12, duration: 0.3),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -12, duration: 0.3)
            ])))
        }
        if self.line2_label.parent == nil
        {
            self.addChild(self.line2_label)
            self.line2_label.childNode(withName: "duck")?.run(.repeatForever(.sequence([
                .wait(forDuration: 0.4),
                .moveBy(x: 0, y: 5, duration: 0.3),
                .moveBy(x: 0, y: -5, duration: 0.3)
            ])))
            self.line2_label.childNode(withName: "star")?.run(.repeatForever(.sequence([
                .scale(to: 1.2, duration: 0.4),
                .scale(to: 0.8, duration: 0.4)
            ])))
            self.line2_label.childNode(withName: "bird")?.run(.repeatForever(.sequence([
                .wait(forDuration: 1),
                .moveBy(x: 0, y: 12, duration: 0.3),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -12, duration: 0.3)
            ])))
            self.line2_label.childNode(withName: "target")?.run(.repeatForever(.sequence([
                .wait(forDuration: 2.5),
                .scaleX(to: -1, duration: 0.3),
                .scaleX(to: 1, duration: 0.3),
                .scaleX(to: -1, duration: 0.3),
                .scaleX(to: 1, duration: 0.3)
            ])))
        }
        if self.line3_label.parent == nil
        {
            self.addChild(self.line3_label)
            self.line3_label.childNode(withName: "target")?.run(.repeatForever(.sequence([
                .wait(forDuration: 2.5),
                .scaleX(to: -1, duration: 0.3),
                .scaleX(to: 1, duration: 0.3),
                .scaleX(to: -1, duration: 0.3),
                .scaleX(to: 1, duration: 0.3)
            ])))
            let leftAngle = radian(degree: 5)
            let rightAngle = radian(degree: -5)
            self.line3_label.childNode(withName: "tree")?.run(.repeatForever(.sequence([
                .wait(forDuration: 2.5),
                .rotate(toAngle: leftAngle, duration: 0.15),
                .rotate(toAngle: rightAngle, duration: 0.25),
                .rotate(toAngle: leftAngle, duration: 0.25),
                .rotate(toAngle: 0, duration: 0.15)
            ])))
        }
        if self.line4_label.parent == nil
        {
            self.addChild(self.line4_label)
            self.line4_label.childNode(withName: "duck")?.run(.repeatForever(.sequence([
                .wait(forDuration: 0.4),
                .moveBy(x: 0, y: 5, duration: 0.3),
                .moveBy(x: 0, y: -5, duration: 0.3)
            ])))
            self.line4_label.childNode(withName: "star")?.run(.repeatForever(.sequence([
                .scale(to: 1.2, duration: 0.4),
                .scale(to: 0.8, duration: 0.4)
            ])))
            self.line4_label.childNode(withName: "bird")?.run(.repeatForever(.sequence([
                .wait(forDuration: 1),
                .moveBy(x: 0, y: 12, duration: 0.3),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -3, duration: 0.15),
                .moveBy(x: 0, y: 3, duration: 0.15),
                .moveBy(x: 0, y: -12, duration: 0.3)
            ])))
            let leftAngle = radian(degree: 30)
            self.line4_label.childNode(withName: "swan")?.run(.repeatForever(.sequence([
                .rotate(toAngle: leftAngle, duration: 1),
                .rotate(toAngle: 0, duration: 1)
            ])))
        }
        if self.line5_label.parent == nil
        {
            self.addChild(self.line5_label)
        }
        if self.line6_label.parent == nil
        {
            self.addChild(self.line6_label)
        }
        if self.quitButton.parent == nil
        {
            self.addChild(self.quitButton)
        }
    }
    
    func showHeadsUpUI()
    {
        if self.starIcon.parent == nil
        {
            self.addChild(self.starIcon)
        }
        if self.scoreText.parent == nil
        {
            self.addChild(self.scoreText)
        }
        if self.countDownText.parent == nil
        {
            self.addChild(self.countDownText)
        }
        for each in self.targetIconHolder
        {
            if each.parent == nil
            {
                self.addChild(each)
            }
        }
        for each in self.targetIcon
        {
            if each.parent == nil
            {
                self.addChild(each)
            }
        }
    }
    
    func hideShootingUI()
    {
        if self.crosshair.parent != nil
        {
            self.crosshair.removeFromParent()
        }
        if self.rifle.parent != nil
        {
            self.rifle.removeFromParent()
        }
        if self.fireButton.parent != nil
        {
            self.fireButton.removeFromParent()
        }
        if self.magazine.parent != nil
        {
            self.magazine.removeFromParent()
        }
        if self.pauseButton.parent != nil
        {
            self.pauseButton.removeFromParent()
        }
    }
    
    func hideStartUI()
    {
        if self.startMenu.parent != nil
        {
            self.startMenu.removeFromParent()
        }
        if self.startButton.parent != nil
        {
            self.startButton.removeFromParent()
        }
        if self.questionButton.parent != nil
        {
            self.questionButton.removeFromParent()
        }
    }
    
    func hidePauseUI()
    {
        if self.pauseMenu.parent != nil
        {
            self.pauseMenu.removeFromParent()
        }
        if self.restartButton.parent != nil
        {
            self.restartButton.removeFromParent()
        }
        if self.startButton.parent != nil
        {
            self.startButton.removeFromParent()
        }
    }
    
    func hideQuitUI()
    {
        if self.quitMenu.parent != nil
        {
            self.quitMenu.removeFromParent()
        }
        if self.restartButton.parent != nil
        {
            self.restartButton.removeFromParent()
        }
    }
    
    func hideRuleUI()
    {
        if self.ruleMenu.parent != nil
        {
            self.ruleMenu.removeFromParent()
        }
        if self.line1_label.parent != nil
        {
            for i in line1_label.children
            {
                i.removeAllActions()
            }
            self.line1_label.removeFromParent()
        }
        if self.line2_label.parent != nil
        {
            for i in line2_label.children
            {
                i.removeAllActions()
            }
            self.line2_label.removeFromParent()
        }
        if self.line3_label.parent != nil
        {
            for i in line3_label.children
            {
                i.removeAllActions()
            }
            self.line3_label.removeFromParent()
        }
        if self.line4_label.parent != nil
        {
            for i in line4_label.children
            {
                i.removeAllActions()
            }
            self.line4_label.removeFromParent()
        }
        if self.line5_label.parent != nil
        {
            self.line5_label.removeFromParent()
        }
        if self.line6_label.parent != nil
        {
            self.line6_label.removeFromParent()
        }
        if self.quitButton.parent != nil
        {
            self.quitButton.removeFromParent()
        }
    }
    
    func hideHeadsUpUI()
    {
        if self.starIcon.parent != nil
        {
            self.starIcon.removeFromParent()
        }
        if self.scoreText.parent != nil
        {
            self.scoreText.removeFromParent()
        }
        if self.countDownText.parent != nil
        {
            self.countDownText.removeFromParent()
        }
        for each in self.targetIconHolder
        {
            if each.parent != nil
            {
                each.removeFromParent()
            }
        }
        for each in self.targetIcon
        {
            if each.parent != nil
            {
                each.removeFromParent()
            }
        }
    }
    
    //MARK: - Animation
    func runAction_321Go()
    {
        let number3 = SKSpriteNode(imageNamed: Image.number3.imageName)
        number3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        number3.zPosition = 9
        number3.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        number3.size.width = self.numberWidth
        number3.size.height = self.numberHeight
        number3.alpha = 0
        self.addChild(number3)
        self.animatedNodes.append(number3)
        
        let number2 = SKSpriteNode(imageNamed: Image.number2.imageName)
        number2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        number2.zPosition = 9
        number2.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        number2.size.width = self.numberWidth
        number2.size.height = self.numberHeight
        number2.alpha = 0
        self.addChild(number2)
        self.animatedNodes.append(number2)
        
        let number1 = SKSpriteNode(imageNamed: Image.number1.imageName)
        number1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        number1.zPosition = 9
        number1.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        number1.size.width = self.numberWidth
        number1.size.height = self.numberHeight
        number1.alpha = 0
        self.addChild(number1)
        self.animatedNodes.append(number1)
        
        let go = SKSpriteNode(imageNamed: Image.go.imageName)
        go.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        go.zPosition = 9
        go.position = CGPoint(x: (self.scene?.frame.midX ?? 406), y: (self.scene?.frame.midY ?? 200))
        go.size.width = self.goWidth
        go.size.height = self.goHeight
        go.alpha = 0
        self.addChild(go)
        self.animatedNodes.append(go)
        
    
        //number3 animation
        number3.run(.sequence([
            .run
            {
                number3.alpha = 1
                number3.xScale = 1.4
                number3.yScale = 1.4
            },
            .scale(to: 1, duration: 0.25),
            .scale(to: 0.3, duration: 0.75),
            .removeFromParent(),
            .run
            {
                self.animatedNodes.remove(
                    at: self.animatedNodes.firstIndex(of: number3)!)
            }
        ]))
        number3.run(.fadeOut(withDuration: 1))
        
        //number2 animation
        number2.run(.sequence([
            .wait(forDuration: 1),
            .run
            {
                number2.alpha = 1
                number2.xScale = 1.4
                number2.yScale = 1.4
            },
            .scale(to: 1, duration: 0.25),
            .scale(to: 0.3, duration: 0.75),
            .removeFromParent(),
            .run
            {
                self.animatedNodes.remove(
                    at: self.animatedNodes.firstIndex(of: number2)!)
            }
        ]))
        number2.run(.sequence([
            .wait(forDuration: 1),
            .fadeOut(withDuration: 1)
        ]))
        
        //number1 animation
        number1.run(.sequence([
            .wait(forDuration: 2),
            .run
            {
                number1.alpha = 1
                number1.xScale = 1.4
                number1.yScale = 1.4
            },
            .scale(to: 1, duration: 0.25),
            .scale(to: 0.3, duration: 0.75),
            .removeFromParent(),
            .run
            {
                self.animatedNodes.remove(
                    at: self.animatedNodes.firstIndex(of: number1)!)
            }
        ]))
        number1.run(.sequence([
            .wait(forDuration: 2),
            .fadeOut(withDuration: 1)
        ]))
        
        //go animation
        go.run(.sequence([
            .wait(forDuration: 3),
            .run
            {
                go.alpha = 1
                go.xScale = 1.4
                go.yScale = 1.4
            },
            .scale(to: 1, duration: 0.25),
            .scale(to: 0.3, duration: 0.75),
            .removeFromParent(),
            .run
            {
                self.animatedNodes.remove(
                    at: self.animatedNodes.firstIndex(of: go)!)
            }
        ]))
        go.run(.sequence([
            .wait(forDuration: 3),
            .fadeOut(withDuration: 1)
        ]))
    }
    
    func removeAnimatedNodes()
    {
        for animated in self.animatedNodes
        {
            animated.removeAllActions()
            animated.removeFromParent()
        }
        self.animatedNodes.removeAll()
    }
    
    //MARK: - Callback
    func endGame()
    {
        self.gameStateMachine.enter(EndingState.self)
    }
}
