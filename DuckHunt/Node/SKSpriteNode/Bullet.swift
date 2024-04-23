import Foundation
import SpriteKit


class Bullet: SKSpriteNode
{
    var hasBullet: Bool = false
    {
        didSet
        {
            if hasBullet
            {
                self.texture = SKTexture(imageNamed: Image.bullet.imageName)
            }
            else
            {
                self.texture = SKTexture(imageNamed: Image.bulletEmpty.imageName)
            }
        }
    }
    
    init ()
    {
        let texture = SKTexture(imageNamed: Image.bulletEmpty.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        name = "bullet"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
