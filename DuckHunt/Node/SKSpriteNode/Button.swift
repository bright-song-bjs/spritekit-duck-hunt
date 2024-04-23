import Foundation
import SpriteKit


class Button: SKSpriteNode
{
    var releasedTexture: SKTexture!
    var pressedTexture: SKTexture!
    var releasedWidth: Double = 75
    var releasedHeight: Double = 75
    var pressedWidth: Double = 77
    var pressedHeight: Double = 77
    
    var isPressed: Bool!
    {
        didSet
        {
            if self.isPressed
            {
                self.texture = self.pressedTexture
                self.size.width = self.pressedWidth
                self.size.height = self.pressedHeight
            }
            else
            {
                self.texture = self.releasedTexture
                self.size.width = self.releasedWidth
                self.size.height = self.releasedHeight
            }
        }
    }
    
    init (releasedTextureName: String, pressedTextureName: String, name: String)
    {
        self.releasedTexture = SKTexture(imageNamed: releasedTextureName)
        self.pressedTexture = SKTexture(imageNamed: pressedTextureName)
        
        super.init(texture: self.releasedTexture, color: .clear, size: self.releasedTexture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size.width = self.releasedWidth
        self.size.height = self.pressedWidth
        self.name = name
        self.isPressed = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class StartButton: Button
{
    init ()
    {        
        super.init(releasedTextureName: Image.startButtonReleased.imageName, pressedTextureName: Image.startButtonPressed.imageName, name: "startButton")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class RestartButton: Button
{
    init ()
    {
        super.init(releasedTextureName: Image.restartButtonReleased.imageName, pressedTextureName: Image.restartButtonPressed.imageName, name: "restartButton")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class QuitButton: Button
{
    init ()
    {
        super.init(releasedTextureName: Image.quitButtonReleased.imageName, pressedTextureName: Image.quitButtonPressed.imageName, name: "quitButton")
        self.releasedWidth = 65
        self.releasedHeight = 65
        self.pressedWidth = 65
        self.pressedHeight = 65
        self.size.width = self.releasedWidth
        self.size.height = self.pressedWidth
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class QuestionButton: Button
{
    init ()
    {
        super.init(releasedTextureName: Image.questionButtonReleased.imageName, pressedTextureName: Image.questionButtonPressed.imageName, name: "questionButton")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class PauseButton: Button
{
    init ()
    {
        super.init(releasedTextureName: Image.pauseButtonReleased.imageName, pressedTextureName: Image.pauseButtonPressed.imageName, name: "pauseButton")
        self.releasedWidth = 40
        self.releasedHeight = 40
        self.pressedWidth = 42
        self.pressedHeight = 42
        self.size.width = self.releasedWidth
        self.size.height = self.pressedWidth
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}


class FireButton: Button
{
    var isReloading = false
    override var isPressed: Bool!
    {
        didSet
        {
            guard !self.isReloading else { return }
            if self.isPressed
            {
                self.texture = self.pressedTexture
                self.size.width = self.pressedWidth
                self.size.height = self.pressedHeight
            }
            else
            {
                self.texture = self.releasedTexture
                self.size.width = self.releasedWidth
                self.size.height = self.releasedHeight
            }
        }
    }

    init ()
    {
        super.init(releasedTextureName: Image.fireButtonReleased.imageName, pressedTextureName: Image.fireButtonPressed.imageName, name: "fireButton")
        self.releasedWidth = 95
        self.releasedHeight = 95
        self.pressedWidth = 97
        self.pressedHeight = 97
        self.size.width = self.releasedWidth
        self.size.height = self.releasedHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
