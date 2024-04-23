import Foundation
import SpriteKit


class Target: SKNode, Shootable
{
    let targetPhysicsBody = SKPhysicsBody(circleOfRadius: 23)
    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    
    //shootable
    var score: Double?
    var shotMarkImageName: String? = Image.shotBlue.imageName
    
    
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
        let targetTexture = SKTexture(imageNamed: "target/\(Int.random(in: 1...3))")
        self.target = SKSpriteNode(texture: targetTexture)
        self.target.name = "target"
        self.target.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.target.position = CGPoint(x: 0, y: 90)
        self.target.size.width = 56.8
        self.target.size.height = 56.8
        
        self.targetPhysicsBody.affectedByGravity = false
        self.targetPhysicsBody.isDynamic = false
        self.targetPhysicsBody.allowsRotation = false
        
        self.stick = SKSpriteNode(imageNamed: "stick_metal")
        self.stick.name = "stick"
        self.stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.stick.position = CGPoint(x: 0, y: 0)
        self.stick.size.width = 17
        self.stick.size.height = 64
        
        self.addChild(self.stick)
        self.addChild(self.target)
    }
    
    func addPhysicsBody()
    {
        self.target.physicsBody = self.targetPhysicsBody
    }
    
    func removePhysicsBody()
    {
        self.target.physicsBody = nil
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
        Utilities.notificationFeedback_success()
        
        self.removePhysicsBody()
        self.run(.sequence([
            .moveBy(x: 0, y: 40, duration: 0.05),
            .moveBy(x: 0, y: -160, duration: 0.3)
        ]))
        self.run(.sequence([
            .scale(to: 0.8, duration: 0.05),
            .scale(to: 0.6, duration: 0.3)
        ]))
    }
}
