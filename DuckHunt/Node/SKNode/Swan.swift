import Foundation
import SpriteKit


class Swan: SKNode, Shootable
{
    var isBlue: Bool!
    var swanPhysicsBody: SKPhysicsBody!
    var normalTexture: SKTexture!
    var hitTexture: SKTexture!
    
    var swan: SKSpriteNode!
    var stick: SKSpriteNode!
    var mark1: SKSpriteNode!
    var mark1Holder: SKSpriteNode!
    var mark2: SKSpriteNode!
    var mark2Holder: SKSpriteNode!
    var mark3: SKSpriteNode!
    var mark3Holder: SKSpriteNode!
    var mark4: SKSpriteNode!
    var mark4Holder: SKSpriteNode!
    var mark5: SKSpriteNode!
    var mark5Holder: SKSpriteNode!
    
    var shotNumber: Int = 0
    
    //shootable
    var score: Double?
    var shotMarkImageName: String? = Image.shotBrown.imageName
    
    
    init(isBlue: Bool = false)
    {
        super.init()
        self.isBlue = isBlue
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize()
    {
        if self.isBlue
        {
            self.name = "blueSwan"
            self.normalTexture = SKTexture(imageNamed: "swan/blue_1")
            self.hitTexture = SKTexture(imageNamed: "swan/blue_2")
        }
        else
        {
            self.name = "pinkSwan"
            self.normalTexture = SKTexture(imageNamed: "swan/pink_1")
            self.hitTexture = SKTexture(imageNamed: "swan/pink_2")
        }
        
        self.swan = SKSpriteNode(texture: self.normalTexture)
        self.swan.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.swan.position = CGPoint(x: 0, y: 127)
        self.swan.size.width = 117.7
        self.swan.size.height = 109.45
        
        self.swanPhysicsBody = SKPhysicsBody(texture: self.normalTexture, alphaThreshold: 0.5, size: CGSize(width: 104.5, height: 94.5))
        self.swanPhysicsBody.affectedByGravity = false
        self.swanPhysicsBody.isDynamic = false
        self.swanPhysicsBody.allowsRotation = false
        
        self.stick = SKSpriteNode(imageNamed: "stick_metal")
        self.stick.name = "stick"
        self.stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.stick.position = CGPoint(x: 0, y: 0)
        self.stick.size.width = 20.4
        self.stick.size.height = 76.8
        
        self.addChild(self.stick)
        self.addChild(self.swan)
        
        //mark1
        self.mark1Holder = SKSpriteNode(imageNamed: Image.circleMarkHolder.imageName)
        self.mark1Holder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark1Holder.position = CGPoint(x: -50, y: 58.5)
        self.mark1Holder.size.width = 18
        self.mark1Holder.size.height = 18
        self.swan.addChild(self.mark1Holder)
        
        self.mark1 = SKSpriteNode(imageNamed: Image.circleMark.imageName)
        self.mark1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark1.position = CGPoint(x: -50, y: 58.5)
        self.mark1.size.width = 13.5
        self.mark1.size.height = 13.5
        self.mark1.alpha = 0
        self.mark1.xScale = 0
        self.mark1.yScale = 0
        self.swan.addChild(self.mark1)
        
        //mark2
        self.mark2Holder = SKSpriteNode(imageNamed: Image.circleMarkHolder.imageName)
        self.mark2Holder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark2Holder.position = CGPoint(x: -26.5, y: 71)
        self.mark2Holder.size.width = 18
        self.mark2Holder.size.height = 18
        self.swan.addChild(self.mark2Holder)
        
        self.mark2 = SKSpriteNode(imageNamed: Image.circleMark.imageName)
        self.mark2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark2.position = CGPoint(x: -26.5, y: 71)
        self.mark2.size.width = 13.5
        self.mark2.size.height = 13.5
        self.mark2.alpha = 0
        self.mark2.xScale = 0
        self.mark2.yScale = 0
        self.swan.addChild(self.mark2)
        
        //mark3
        self.mark3Holder = SKSpriteNode(imageNamed: Image.circleMarkHolder.imageName)
        self.mark3Holder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark3Holder.position = CGPoint(x: 0, y: 75.5)
        self.mark3Holder.size.width = 18
        self.mark3Holder.size.height = 18
        self.swan.addChild(self.mark3Holder)
        
        self.mark3 = SKSpriteNode(imageNamed: Image.circleMark.imageName)
        self.mark3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark3.position = CGPoint(x: 0, y: 75.5)
        self.mark3.size.width = 13.5
        self.mark3.size.height = 13.5
        self.mark3.alpha = 0
        self.mark3.xScale = 0
        self.mark3.yScale = 0
        self.swan.addChild(self.mark3)
        
        //mark4
        self.mark4Holder = SKSpriteNode(imageNamed: Image.circleMarkHolder.imageName)
        self.mark4Holder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark4Holder.position = CGPoint(x: 26.5, y: 71)
        self.mark4Holder.size.width = 18
        self.mark4Holder.size.height = 18
        self.swan.addChild(self.mark4Holder)
        
        self.mark4 = SKSpriteNode(imageNamed: Image.circleMark.imageName)
        self.mark4.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark4.position = CGPoint(x: 26.5, y: 71)
        self.mark4.size.width = 13.5
        self.mark4.size.height = 13.5
        self.mark4.alpha = 0
        self.mark4.xScale = 0
        self.mark4.yScale = 0
        self.swan.addChild(self.mark4)
        
        //mark5
        self.mark5Holder = SKSpriteNode(imageNamed: Image.circleMarkHolder.imageName)
        self.mark5Holder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark5Holder.position = CGPoint(x: 50, y: 58.5)
        self.mark5Holder.size.width = 18
        self.mark5Holder.size.height = 18
        self.swan.addChild(self.mark5Holder)
        
        self.mark5 = SKSpriteNode(imageNamed: Image.circleMark.imageName)
        self.mark5.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mark5.position = CGPoint(x: 50, y: 58.5)
        self.mark5.size.width = 13.5
        self.mark5.size.height = 13.5
        self.mark5.alpha = 0
        self.mark5.xScale = 0
        self.mark5.yScale = 0
        self.swan.addChild(self.mark5)
    }
    
    func addPhysicsBody()
    {
        self.swan.physicsBody = self.swanPhysicsBody
    }
    
    func removePhysicsBody()
    {
        self.swan.physicsBody = nil
    }
    
    func restore()
    {
        self.removeAllActions()
        self.zRotation = 0
        self.setScale(1)
    }
    
    func wasShot()
    {
        self.shotNumber += 1
        
        if self.shotNumber < 5
        {
            //haptic
            Utilities.impactFeedback_soft()
            
            self.run(.sequence([
                .run
                {
                    self.swan.texture = self.hitTexture
                },
                .moveBy(x: 0, y: 20, duration: 0.08),
                .moveBy(x: 0, y: -40, duration: 0.21),
                .moveBy(x: 0, y: 40, duration: 0.13),
                .moveBy(x: 0, y: -20, duration: 0.16),
                .run
                {
                    self.swan.texture = self.normalTexture
                }
            ]))
            
            switch self.shotNumber
            {
                case 1:
                    self.mark1.run(.fadeIn(withDuration: 0.3))
                    self.mark1.run(.sequence([
                        .scale(to: 1.2, duration: 0.3),
                        .scale(to: 1, duration: 0.2)
                    ]))
                case 2:
                    self.mark2.run(.fadeIn(withDuration: 0.3))
                    self.mark2.run(.sequence([
                        .scale(to: 1.2, duration: 0.3),
                        .scale(to: 1, duration: 0.2)
                    ]))
                case 3:
                    self.mark3.run(.fadeIn(withDuration: 0.3))
                    self.mark3.run(.sequence([
                        .scale(to: 1.2, duration: 0.3),
                        .scale(to: 1, duration: 0.2)
                    ]))
                case 4:
                    self.mark4.run(.fadeIn(withDuration: 0.3))
                    self.mark4.run(.sequence([
                        .scale(to: 1.2, duration: 0.3),
                        .scale(to: 1, duration: 0.2)
                    ]))
                default: break
            }
        }
        else if self.shotNumber == 5
        {
            //haptic
            Utilities.notificationFeedback_error()
            
            //self
            self.mark5.run(.fadeIn(withDuration: 0.3))
            self.mark5.run(.sequence([
                .scale(to: 1.2, duration: 0.3),
                .scale(to: 1, duration: 0.2),
                .run {
                    self.mark1.removeFromParent()
                    self.mark2.removeFromParent()
                    self.mark3.removeFromParent()
                    self.mark4.removeFromParent()
                    self.mark5.removeFromParent()
                    self.mark1Holder.removeFromParent()
                    self.mark2Holder.removeFromParent()
                    self.mark3Holder.removeFromParent()
                    self.mark4Holder.removeFromParent()
                    self.mark5Holder.removeFromParent()
                }
            ]))
            
            self.removePhysicsBody()
            self.run(.sequence([
                .run
                {
                    self.swan.texture = self.hitTexture
                },
                .moveBy(x: 0, y: 20, duration: 0.1),
                .moveBy(x: 0, y: -40, duration: 0.2),
                .moveBy(x: 0, y: 40, duration: 0.2),
                .moveBy(x: 0, y: -40, duration: 0.2),
                .moveBy(x: 0, y: 40, duration: 0.2),
                .moveBy(x: 0, y: -200, duration: 0.3),
                .removeFromParent()
            ]))
            
            //audio
            self.run(.repeat(.sequence([
                .run
                {
                    Audio.sharedInstance.playSound(soundFileName: Sound.score.fileName)
                },
                .wait(forDuration: 0.12)
            ]), count: 3))
            
            //duck
            for i in Shared.sharedInstance.stageScene!.spriteGenerator.generatedDuck
            {
                i.removeAllActions()
                
                //add score text to the scene
                let actualScore = i.score! * Shared.sharedInstance.stageScene!.shooting.currentScoreMultiplier
                let number = Int(actualScore)
                let text = "+" + String(number)
                let scoreText = Utilities.getNumberNode(from: text, anchor_x: true, anchor_y: true)
                scoreText.xScale = 0.9
                scoreText.yScale = 0.9
                scoreText.zPosition = 9
                scoreText.position = CGPoint(x: (i.position.x + Shared.sharedInstance.stageScene!.shooting.scoreTextOffset.x), y: (i.position.y + Shared.sharedInstance.stageScene!.shooting.scoreTextOffset.y))
                Utilities.runAction_addScore(scoreText: scoreText, in: Shared.sharedInstance.stageScene!)
                
                //update total score
                Shared.sharedInstance.stageScene?.shooting.currentScore += actualScore
                
                i.run(.sequence([
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1)
                ]))
                i.run(.sequence([
                    .moveBy(x: 0, y: 20, duration: 0.4),
                    .wait(forDuration: 0.3),
                    .moveBy(x: 0, y: -200, duration: 0.3),
                    .run
                    {
                        i.removeFromParent()
                    }
                ]))
            }
            
            //bird
            for i in Shared.sharedInstance.stageScene!.spriteGenerator.generatedBird
            {
                i.removeAllActions()
                
                //add score text to the scene
                let actualScore = i.score! * Shared.sharedInstance.stageScene!.shooting.currentScoreMultiplier
                let number = Int(actualScore)
                let text = "+" + String(number)
                let scoreText = Utilities.getNumberNode(from: text, anchor_x: true, anchor_y: true)
                scoreText.xScale = 0.9
                scoreText.yScale = 0.9
                scoreText.zPosition = 9
                scoreText.position = CGPoint(x: (i.position.x + Shared.sharedInstance.stageScene!.shooting.scoreTextOffset.x), y: (i.position.y + Shared.sharedInstance.stageScene!.shooting.scoreTextOffset.y))
                Utilities.runAction_addScore(scoreText: scoreText, in: Shared.sharedInstance.stageScene!)
                
                //update total score
                Shared.sharedInstance.stageScene?.shooting.currentScore += actualScore
                
                i.run(.sequence([
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1),
                    .scaleX(to: -1, duration: 0.1),
                    .scaleX(to: 1, duration: 0.1)
                ]))
                i.run(.sequence([
                    .moveBy(x: 0, y: -20, duration: 0.4),
                    .wait(forDuration: 0.3),
                    .moveBy(x: 0, y: 300, duration: 0.3),
                    .run
                    {
                        i.removeFromParent()
                    }
                ]))
            }
        }
        
    }
}
