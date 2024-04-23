import Foundation
import SpriteKit


class Magazine: SKNode
{
    var bullets = Array<Bullet>()
    var capacity: Int
    var singleReloadingTime: Double
    
    
    init (capacity: Int, reloadingTime: Double, spacing: Double)
    {
        self.capacity = capacity
        self.singleReloadingTime = reloadingTime / Double(capacity)
        
        super.init()
        
        for i in 0...(capacity - 1)
        {
            let bullet = Bullet()
            bullet.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bullet.position = CGPoint(x: -spacing * Double(i), y: 0)
            bullet.xScale = 0.8
            bullet.yScale = 0.8
            self.bullets.append(bullet)
            self.addChild(bullet)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //find the first bullet in magazine then shoot it (make it empty)
    func shoot()
    {
        self.bullets.last
        { (bullet) -> Bool in
            bullet.hasBullet == true
        }?.hasBullet = false
    }
    
    //check if the magazine is completely empty
    func allEmpty() -> Bool
    {
        return self.bullets.allSatisfy
        { (bullet) in
            bullet.hasBullet == false
        }
    }
    
    //check if the magezine is full
    func allFull() -> Bool
    {
        return self.bullets.allSatisfy
        { (bullet) in
            bullet.hasBullet == true
        }
    }
    
    //fill the magazine whether it's completely empty or not
    func reload()
    {
        for bullet in self.bullets
        {
            if !bullet.hasBullet
            {
                bullet.hasBullet = true
            }
        }
    }
    
    //only fill the magazine when it's completely empty
    func reloadIfAllEmpty()
    {
        if self.allEmpty()
        {
            for bullet in self.bullets
            {
                bullet.hasBullet = true
            }
        }
    }
}
