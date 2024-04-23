import Foundation
import SpriteKit


class Tree: SKNode, Shootable
{
    static var shotTrees = Array<Tree>()
    
    var tree: SKSpriteNode!
    let shotThreshold: Int = 3
    var shotNumber: Int = 0
    var originalZRotation: Double!
    var plantedScene: SKScene?
    
    //shootable
    var score: Double?
    var shotMarkImageName: String? = Image.shotBrown.imageName
    
    init(texture: SKTexture)
    {
        super.init()
        
        let pineTreePhysicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: texture.size())
        self.tree = SKSpriteNode(texture: texture)
        pineTreePhysicsBody.isDynamic = false
        pineTreePhysicsBody.affectedByGravity = false
        pineTreePhysicsBody.allowsRotation = false
        self.tree.physicsBody = pineTreePhysicsBody
      
        self.addChild(self.tree)
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.originalZRotation = self.zRotation
        
        //get its scene with delay because the tree was not added to the scene until initialization was finished
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false)
        {
            _ in
            self.plantedScene = self.scene
        }
    }
    
    static func restoreAllTrees()
    {
        for shotTree in Tree.shotTrees
        {
            shotTree.restore()
        }
        Tree.shotTrees.removeAll()
    }
    
    func restore()
    {
        //add to the scene
        if self.scene == nil
        {
            (self.plantedScene ?? Shared.sharedInstance.stageScene!).addChild(self)
        }
        
        self.removeAllActions()
        self.zRotation = self.originalZRotation
        self.shotNumber = 0
        
        //clear shot mark
        for child in self.children[0].children
        {
            child.removeFromParent()
        }
    }
    
    func wasShot()
    {
        self.shotNumber += 1
        if self.shotNumber < self.shotThreshold
        {
            if self.shotNumber == 1
            {
                Tree.shotTrees.append(self)
            }
            self.shake()
        }
        else if self.shotNumber == self.shotThreshold
        {
            if self.zRotation > radian(degree: 3)
            {
                self.fallsLeft()
            }
            else if self.zRotation < radian(degree: -3)
            {
                self.fallsRight()
            }
            else
            {
                let randomBool = Bool.random()
                if randomBool
                {
                    self.fallsLeft()
                }
                else
                {
                    self.fallsRight()
                }
            }
        }
    }
    
    private func shake()
    {
        self.removeAction(forKey: ActionKey.treeShaking.key)
        self.run(.sequence([
            .rotate(byAngle: radian(degree: -0.9), duration: 0.1),
            .rotate(byAngle: radian(degree: 1.8), duration: 0.1),
            .rotate(byAngle: radian(degree: -0.9), duration: 0.1),
        ]), withKey: ActionKey.treeShaking.key)
    }
    
    private func fallsLeft()
    {
        self.removeAction(forKey: ActionKey.treeShaking.key)
        self.run(.sequence([
            .rotate(byAngle: radian(degree: 1.1), duration: 0.1),
            .rotate(byAngle: radian(degree: -2.2), duration: 0.1),
            .rotate(byAngle: radian(degree: 1.8), duration: 0.1),
            .rotate(toAngle: radian(degree: 15), duration: 0.9),
            .rotate(toAngle: radian(degree: 30), duration: 0.7),
            .rotate(toAngle: radian(degree: 45), duration: 0.4),
            .rotate(toAngle: radian(degree: 60), duration: 0.25),
            .rotate(toAngle: radian(degree: 75), duration: 0.1),
            .rotate(toAngle: radian(degree: 90), duration: 0.08),
            .wait(forDuration: 0.5),
            .removeFromParent()
        ]), withKey: ActionKey.treeShaking.key)
    }
    
    private func fallsRight()
    {
        self.removeAction(forKey: ActionKey.treeShaking.key)
        self.run(.sequence([
            .rotate(byAngle: radian(degree: -1.1), duration: 0.1),
            .rotate(byAngle: radian(degree: 2.2), duration: 0.1),
            .rotate(byAngle: radian(degree: -1.8), duration: 0.1),
            .rotate(toAngle: radian(degree: -15), duration: 0.9),
            .rotate(toAngle: radian(degree: -30), duration: 0.7),
            .rotate(toAngle: radian(degree: -45), duration: 0.4),
            .rotate(toAngle: radian(degree: -60), duration: 0.25),
            .rotate(toAngle: radian(degree: -75), duration: 0.1),
            .rotate(toAngle: radian(degree: -90), duration: 0.08),
            .wait(forDuration: 0.5),
            .removeFromParent()
        ]), withKey: ActionKey.treeShaking.key)
    }
}


class PineTree: Tree
{
    let pineTreeTexture = SKTexture(imageNamed: Image.pineTree.imageName)

    init()
    {
        super.init(texture: self.pineTreeTexture)
        
        self.tree.name = "pineTree"
        self.tree.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.tree.position = CGPoint(x: 0, y: 127.5)
        self.tree.xScale = 1
        self.tree.yScale = 1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

class OakTree: Tree
{
    let oakTreeTexture = SKTexture(imageNamed: Image.oakTree.imageName)

    init()
    {
        super.init(texture: self.oakTreeTexture)
        
        self.tree.name = "oakTree"
        self.tree.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.tree.position = CGPoint(x: 0, y: 122)
        self.tree.xScale = 1
        self.tree.yScale = 1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

