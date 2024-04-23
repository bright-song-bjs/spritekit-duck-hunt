import Foundation
import SpriteKit


class BackGround: SKNode, Shootable
{
    var score: Double?
    var shotMarkImageName: String? = Image.shotBlue.imageName
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func wasShot()
    {
        self.run(.sequence([
            .moveBy(x: 0, y: -1, duration: 0.2),
            .moveBy(x: 0, y: 1, duration: 0.2)
        ]))
    }
}


class Curtain: SKNode, Shootable
{
    var score: Double?
    var shotMarkImageName: String? = Image.shotBlue.imageName
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func wasShot()
    {
        let scale = self.xScale
        self.removeAction(forKey: ActionKey.curtainShaking.key)
        self.run(.sequence([
            .rotate(byAngle: radian(degree: -0.9 * scale), duration: 0.14),
            .rotate(byAngle: radian(degree: 1.4 * scale), duration: 0.25),
            .rotate(byAngle: radian(degree: -0.5 * scale), duration: 0.18)
        ]), withKey: ActionKey.curtainShaking.key)
    }
}
