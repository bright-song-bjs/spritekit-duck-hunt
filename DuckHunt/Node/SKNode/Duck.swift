import Foundation
import SpriteKit


class Duck: SKNode, Shootable
{
    var hasTarget: Bool!
    var duckPhysicsBody: SKPhysicsBody!
    var duck: SKSpriteNode!
    var stick: SKSpriteNode!
    
    //shootable
    var score: Double?
    var shotMarkImageName: String? = Image.shotBrown.imageName

    
    init(hasTarget: Bool = false)
    {
        super.init()
        self.hasTarget = hasTarget
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize()
    {
        let duckImageName: String!
        let duckNodeName: String!
        let duckTexture: SKTexture!
        
        if self.hasTarget
        {
            duckImageName = "duck_target/\(Int.random(in: 1...3))"
            duckTexture = SKTexture(imageNamed: duckImageName)
            duckNodeName = "targetDuck"
            self.score = 20
        }
        else
        {
            duckImageName = "duck/\(Int.random(in: 1...3))"
            duckTexture = SKTexture(imageNamed: duckImageName)
            duckNodeName = "duck"
            self.score = 10
        }
        
        self.duck = SKSpriteNode(texture: duckTexture)
        self.duck.name = duckNodeName
        self.duck.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.duck.position = CGPoint(x: 0, y: 107)
        self.duck.size.width = 68.4
        self.duck.size.height = 65.4
        
        self.duckPhysicsBody = SKPhysicsBody(texture: duckTexture, alphaThreshold: 0.5, size: CGSize(width: 56, height: 55))
        self.duckPhysicsBody.affectedByGravity = false
        self.duckPhysicsBody.isDynamic = false
        self.duckPhysicsBody.allowsRotation = false
        
        self.stick = SKSpriteNode(imageNamed: "stick/\(Int.random(in: 1...2))")
        self.stick.name = "stick"
        self.stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.stick.position = CGPoint(x: 0, y: 0)
        self.stick.size.width = 20.4
        self.stick.size.height = 76.8
        
        self.addChild(self.stick)
        self.addChild(self.duck)
    }
    
    func addPhysicsBody()
    {
        self.duck.physicsBody = self.duckPhysicsBody
    }
    
    func removePhysicsBody()
    {
        self.duck.physicsBody = nil
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
        
        self.removePhysicsBody()
        if self.hasTarget
        {
            self.run(.sequence([
                .moveBy(x: 0, y: 20, duration: 0.24),
                .moveBy(x: 0, y: -160, duration: 0.3)
            ]))
            self.run(.sequence([
                .scaleX(to: -1, duration: 0.12),
                .scaleX(to: 1, duration: 0.12)
            ]))
        }
        else
        {
            self.run(.sequence([
                .moveBy(x: 0, y: 20, duration: 0.22),
                .moveBy(x: 0, y: -160, duration: 0.3)
            ]))
            self.duck.run(.sequence([
                .rotate(toAngle: radian(degree: 25), duration: 0.17),
                .rotate(toAngle: radian(degree: -50), duration: 0.15)
            ]))
        }
    }
}
