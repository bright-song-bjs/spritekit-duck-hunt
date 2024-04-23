import Foundation
import SpriteKit


class Bird: SKNode, Shootable
{
    var birdPhysicsBody: SKPhysicsBody!
    var bird: SKSpriteNode!
    var stick: SKSpriteNode!
    var moveDuration: Double?
    
    //shootable
    var score: Double?
    var shotMarkImageName: String? = Image.shotBrown.imageName
    
    
    override init()
    {
        super.init()
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize()
    {
        self.score = 30
        let birdTexture = SKTexture(imageNamed: "bird/\(Int.random(in: 1...4))")
        self.bird = SKSpriteNode(texture: birdTexture)
        self.bird.name = "bird"
        self.bird.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.bird.position = CGPoint(x: 0.7, y: -189)
        self.bird.size.width = 54.8
        self.bird.size.height = 43.8
        
        self.birdPhysicsBody = SKPhysicsBody(texture: birdTexture, alphaThreshold: 0.5, size: CGSize(width: 41.5, height: 35))
        self.birdPhysicsBody.affectedByGravity = false
        self.birdPhysicsBody.isDynamic = false
        self.birdPhysicsBody.allowsRotation = false
        
        self.stick = SKSpriteNode(imageNamed: "stick_long")
        self.stick.name = "stick"
        self.stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.position = CGPoint(x: 0, y: 0)
        self.stick.size.width = 11.4
        self.stick.size.height = 195
        self.stick.yScale = -1
        
        self.addChild(self.stick)
        self.addChild(self.bird)
    }
    
    func addPhysicsBody()
    {
        self.bird.physicsBody = self.birdPhysicsBody
    }
    
    func removePhysicsBody()
    {
        self.bird.physicsBody = nil
    }
    
    func restore()
    {
        self.removeAllActions()
        self.zRotation = 0
        self.setScale(1)
    }
    
    func wasShot()
    {
        //haptic
        Utilities.impactFeedback_soft()
        
        let moveDuration = self.moveDuration ?? 5
        let degree: Double
        
        if moveDuration > 10
        {
            degree = 8
        }
        else if moveDuration > 7
        {
            degree = 12
        }
        else if moveDuration > 4
        {
            degree = 22
        }
        else if moveDuration > 3
        {
            degree = 35
        }
        else if moveDuration > 2
        {
            degree = 45
        }
        else if moveDuration > 1
        {
            degree = 55
        }
        else
        {
            degree = 70
        }
        
        self.removePhysicsBody()
        self.removeAllActions()
        self.stick.run(.sequence([
            .rotate(byAngle: radian(degree: -degree), duration: 0.3),
            .rotate(byAngle: radian(degree: degree * 1.7), duration: 1.1),
            .rotate(byAngle: radian(degree: -degree * 1.2), duration: 0.9)
        ]))
        self.stick.run(.sequence([
            .wait(forDuration: 1.9),
            .moveBy(x: 0, y: 210, duration: 1)]))
        self.bird.run(.rotate(byAngle:26, duration: 1.8))
        self.bird.run(.moveBy(x: 0, y: -400, duration: 1.4))
    }
}
