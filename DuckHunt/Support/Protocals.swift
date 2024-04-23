import Foundation
import SpriteKit


protocol Shootable
{
    var shotMarkImageName: String? {get set}
    var score: Double? {get set}
    
    func wasShot()
}
