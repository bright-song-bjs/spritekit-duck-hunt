import Foundation
import SpriteKit


class Crosshair: SKSpriteNode
{
    init ()
    {
        let texture = SKTexture(imageNamed: Image.crosshair.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size.width = 37.8
        self.size.height = 37.8
        self.name = "crosshair"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
