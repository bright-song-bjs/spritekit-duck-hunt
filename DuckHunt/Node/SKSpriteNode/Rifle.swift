import Foundation
import SpriteKit


class Rifle: SKSpriteNode
{
    init ()
    {
        let texture = SKTexture(imageNamed: Image.rifle.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.3)
        self.size.width = 89.4
        self.size.height = 204.7
        self.name = "refle"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
