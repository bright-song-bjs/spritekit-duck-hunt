import Foundation
import SpriteKit
import GameplayKit


class SpriteGenerator
{
    //MARK: - Values
    //generate duck settings
    
    //move time and interval
    let duckMoveDuration: Double = 7.5  //change throughout the game
    let duckMoveDurationOffset: Double = 0.9  //change throughout the game
    let targetDuckMoveDuration: Double = 4.2  //change throughout the game
    let targetDuckMoveDurationOffset: Double = 0.6  //change throughout the game
    let multiplier_duck: Double = 0.22
    let multiplier_targetDuck: Double = 0.16
    let generateDuckInterval: Double = 1
    
    //height
    let generateDuckHeight: Int = 52
    let genetateDuckHeightOffset: Int = 10
    

    //generate target settings
    
    //move time and interval
    let targetStayDuration: Double = 3  //change throughout the  game
    let targetStayDurationOffset: Double = 0.6  //change throughout the  game
    let multiplier_target: Double = 0.22
    let generateTargetInterval: Double = 4
    
    //height and x position
    let generateTargetXPosition: [Int] = [45, 105, 165, 225, 285, 345, 405, 465, 525, 585, 645, 705, 765]
    let generateTargetHeight: Int = 113
    let generateTargetHeightOffset: Int = 15
    
    
    //generate bird settings
    
    //move time and interval
    let birdMoveDuration: Double = 7  //change throughout the game
    let birdMoveDurationOffset: Double = 1  //change throughout the game
    let multiplier_bird: Double = 0.22
    let generateBirdInterval: Double = 2
    
    //height
    let birdMaxFlyingHeight: Int = 484
    let birdMinFlyingHeight: Int = 390
    let direTionChangeNumber: [Int] = [5, 6, 7, 8, 9, 10]
    
    
    //generate swan settings
    
    //height
    let generateSwanHeight: Int = 36
    let genetateSwanHeightOffset: Int = 5
    let generateSwanInterval: Double = 17.5
    let swanMoveDuration: Double = 8
    
 

    //scene
    unowned var stageScene: StageScene!
    
    //duck
    var _duckMoveDuration: Double!
    var _duckMoveDurationOffset: Double!
    var _targetDuckMoveDuration: Double!
    var _targetDuckMoveDurationOffset: Double!
    var duckZPositionOffset = 0.001
    {
        didSet
        {
            if self.duckZPositionOffset == 1
            {
                self.duckZPositionOffset = 0.001
            }
        }
    }
    var decrement_duck: Double!
    var decrement_targetDuck: Double!
    var decrement_duck_offset: Double!
    var decrement_targetDuck_offset: Double!
    var generatedDuck = Array<Duck>()
    
    //target
    var _targetStayDuration: Double!
    var _targetStayDurationOffset: Double!
    var usingTargetXPosition = Array<Int>()
    var decrement_target: Double!
    var decrement_target_offset: Double!
    var generatedTarget = Array<Target>()
    
    //bird
    var _birdMoveDuration: Double!
    var _birdMoveDurationOffset: Double!
    var birdZPositionOffset = 0.001
    {
        didSet
        {
            if self.birdZPositionOffset == 1
            {
                self.birdZPositionOffset = 0.001
            }
        }
    }
    var decrement_bird: Double!
    var decrement_bird_offset: Double!
    var generatedBird = Array<Bird>()
    
    //swan
    var generatedSwan = Array<Swan>()
    
    //generator
    var duckGenerator: Timer?
    var targetGenerator: Timer?
    var birdGenerator: Timer?
    var swanGenerator: Timer?
    var isDuckGenerating = false
    var isTargetGenerating = false
    var isBirdGenerating = false
    var isSwanGenerating = false
    var hasDuckGeneratorStarted = false
    var hasTargetGeneratorStarted = false
    var hasBirdGeneratorStarted = false
    var hasSwanGeneratorStarted = false
    
    
    init(stageScene: StageScene)
    {
        self.stageScene = stageScene
        self._duckMoveDuration = self.duckMoveDuration
        self._duckMoveDurationOffset = self.duckMoveDurationOffset
        self._targetDuckMoveDuration = self.targetDuckMoveDuration
        self._targetDuckMoveDurationOffset = self.targetDuckMoveDurationOffset
        
        self._targetStayDuration = self.targetStayDuration
        self._targetStayDurationOffset = self.targetStayDurationOffset
        
        self._birdMoveDuration = self.birdMoveDuration
        self._birdMoveDurationOffset = self.birdMoveDurationOffset
    }
    
    //MARK: - Generator
    private func activateDuckGenerator()
    {
        self.decrement_duck = self._duckMoveDuration * self.multiplier_duck * self.generateDuckInterval / 60
        self.decrement_duck_offset = self._duckMoveDurationOffset * self.multiplier_duck * self.generateDuckInterval / 60
        self.decrement_targetDuck = self._targetDuckMoveDuration *
        self.multiplier_targetDuck * self.generateDuckInterval / 60
        self.decrement_targetDuck_offset = self._targetDuckMoveDurationOffset * self.multiplier_targetDuck * self.generateDuckInterval / 60
        
        self.duckGenerator = Timer.scheduledTimer(withTimeInterval: self.generateDuckInterval, repeats: true)
        { (timer) in
            if !self.isDuckGenerating { return }
           
            let duck = Duck(hasTarget: Bool.random())
            self.generatedDuck.append(duck)
            duck.addPhysicsBody()
            let duration: TimeInterval
            
            duck.position = CGPoint(x: -10, y: Int.random(in: (self.generateDuckHeight - self.genetateDuckHeightOffset)...(self.generateDuckHeight + self.genetateDuckHeightOffset)))
            duck.zPosition = (Int.random(in: 0...1) == 0 ? 4 : 6) + self.duckZPositionOffset
            self.duckZPositionOffset += 0.001
            
            self.stageScene.scene?.addChild(duck)
            
            if duck.hasTarget
            {
                duration = TimeInterval(Double.random(in:(self._targetDuckMoveDuration - self._targetDuckMoveDurationOffset)...(self._targetDuckMoveDuration + self._targetDuckMoveDurationOffset)))
            }
            else
            {
                duration = TimeInterval(Double.random(in:(self._duckMoveDuration - self._duckMoveDurationOffset)...(self._duckMoveDuration + self._duckMoveDurationOffset)))
            }
            
            duck.run(.sequence([
                .moveTo(x: 850, duration: duration),
                .removeFromParent(),
                .run
                {
                    self.generatedDuck.remove(
                        at: self.generatedDuck.firstIndex(of: duck)!)
                }
            ]))
            
            //linear decrement
            if self._duckMoveDuration > self.decrement_duck
            {
                self._duckMoveDuration -= self.decrement_duck
            }
            if self._targetDuckMoveDuration > self.decrement_targetDuck
            {
                self._targetDuckMoveDuration -= self.decrement_targetDuck
            }
            if self._duckMoveDurationOffset > self.decrement_duck_offset
            {
                self._duckMoveDurationOffset -= self.decrement_duck_offset
            }
            if self._targetDuckMoveDurationOffset > self.decrement_targetDuck_offset
            {
                self._targetDuckMoveDurationOffset -= self.decrement_targetDuck_offset
            }
        }
    }
    
    private func activateTargetGenerator()
    {
        self.decrement_target = self._targetStayDuration * self.multiplier_target * self.generateTargetInterval / 60
        self.decrement_target_offset = self._targetStayDuration * self.multiplier_target * self.generateTargetInterval / 60
        
        self.targetGenerator = Timer.scheduledTimer(withTimeInterval: self.generateTargetInterval, repeats: true)
        { (timer) in
            if !self.isTargetGenerating { return }
            
            let target = Target()
            self.generatedTarget.append(target)
            
            var xPosition = self.generateTargetXPosition.randomElement()!
            while self.usingTargetXPosition.contains(xPosition)
            {
                xPosition = self.generateTargetXPosition.randomElement()!
            }
            self.usingTargetXPosition.append(xPosition)
            
            target.position = CGPoint(x: xPosition, y: Int.random(in: (self.generateTargetHeight - self.generateTargetHeightOffset)...(self.generateTargetHeight + self.generateTargetHeightOffset)))
            target.zPosition = 1
            target.yScale = 0
            
            self.stageScene.scene?.addChild(target)
            
            target.run(.sequence([
                .scaleY(to: 1.25, duration: 0.2),
                .scaleY(to: 0.92, duration: 0.1),
                .scaleY(to: 1, duration: 0.05),
                .run
                {
                    target.addPhysicsBody()
                },
                .wait(forDuration: TimeInterval(Double.random(in: (self._targetStayDuration - self._targetStayDurationOffset)...(self._targetStayDuration + self._targetStayDurationOffset)))),
                .scaleY(to: 0, duration: 0.2),
                .removeFromParent(),
                .run
                {
                    self.usingTargetXPosition.remove(
                        at: self.usingTargetXPosition.firstIndex(of: xPosition)!)
                    self.generatedTarget.remove(
                        at: self.generatedTarget.firstIndex(of: target)!)
                }
            ]))
            
            //linear decrement
            if self._targetStayDuration > self.decrement_target
            {
                self._targetStayDuration -= self.decrement_target
            }
            if self._targetStayDurationOffset > self.decrement_target_offset
            {
                self._targetStayDurationOffset -= self.decrement_target_offset
            }
        }
    }
    
    private func activateBirdGenerator()
    {
        self.decrement_bird = self._birdMoveDuration * self.multiplier_bird * self.generateBirdInterval / 60
        self.decrement_bird_offset = self._birdMoveDurationOffset * self.multiplier_bird * self.generateBirdInterval / 60
        
        self.birdGenerator = Timer.scheduledTimer(withTimeInterval: self.generateBirdInterval, repeats: true)
        {
            (timer) in
            if !self.isBirdGenerating { return }
            
            let bird = Bird()
            self.generatedBird.append(bird)
            bird.addPhysicsBody()
            
            bird.position = CGPoint(x: 835, y: Int.random(in: self.birdMinFlyingHeight...self.birdMaxFlyingHeight))
            bird.zPosition = 4 + self.birdZPositionOffset
            self.birdZPositionOffset += 0.001
            
            self.stageScene.scene?.addChild(bird)
            
            let duration = Double.random(in: (self._birdMoveDuration - self._birdMoveDurationOffset)...(self._birdMoveDuration + self._birdMoveDurationOffset))
            let number: Int! = self.direTionChangeNumber.randomElement()
            let singleTime = duration / Double(number)
            var offset: Double = 0
            var waitTime: Double = 0
            
            bird.moveDuration = duration
            bird.run(.sequence([
                .moveTo(x: -15, duration: duration),
                .removeFromParent(),
                .run
                {
                    self.generatedBird.remove(
                        at: self.generatedBird.firstIndex(of: bird)!)
                }
            ]))
            bird.run(.run({
                for i in 1...number
                {
                    if (i % 2) == 0
                    {
                        let singleDuration = singleTime - offset
                        bird.run(.sequence([
                            .wait(forDuration: waitTime),
                            .moveTo(y: Double(Int.random(in: self.birdMinFlyingHeight...self.birdMaxFlyingHeight)), duration: singleDuration)
                        ]))
                        waitTime += singleDuration
                    }
                    else
                    {
                        if i == number
                        {
                            bird.run(.sequence([
                                .wait(forDuration: waitTime),
                                .moveTo(y: Double(Int.random(in: self.birdMinFlyingHeight...self.birdMaxFlyingHeight)), duration: singleTime)
                            ]))
                        }
                        else
                        {
                            offset = Double.random(in: (-singleTime * 0.5)...(singleTime * 0.5))
                            let singleDuration = singleTime + offset
                            bird.run(.sequence([
                                .wait(forDuration: waitTime),
                                .moveTo(y: Double(Int.random(in: self.birdMinFlyingHeight...self.birdMaxFlyingHeight)), duration: singleDuration)
                            ]))
                            waitTime += singleDuration
                        }
                    }
                }
            }))
            
            //linear decrement
            if self._birdMoveDuration > self.decrement_bird
            {
                self._birdMoveDuration -= self.decrement_bird
            }
            if self._birdMoveDurationOffset > self.decrement_bird_offset
            {
                self._birdMoveDurationOffset -= self.decrement_bird_offset
            }
        }
        
    }
    
    private func activateSwanGenerator()
    {
        self.swanGenerator = Timer.scheduledTimer(withTimeInterval: self.generateSwanInterval, repeats: true)
        {
            (timer) in
            if !self.isSwanGenerating { return }
            
            let swan = Swan(isBlue: Bool.random())
            self.generatedSwan.append(swan)
            swan.addPhysicsBody()
            
            swan.position = CGPoint(x: -10, y: Int.random(in: (self.generateSwanHeight - self.genetateSwanHeightOffset)...(self.generateSwanHeight + self.genetateSwanHeightOffset)))
            swan.zPosition = 3.9
            
            self.stageScene.scene?.addChild(swan)
            
            swan.run(.sequence([
                .moveTo(x: 850, duration: self.swanMoveDuration),
                .removeFromParent(),
                .run {
                    self.generatedSwan.remove(
                        at: self.generatedSwan.firstIndex(of: swan)!)
                }
            ]))
        }
    }
    
    //MARK: - Start Generator
    func startDuckGenerator(delay: Double = 0)
    {
        self.hasDuckGeneratorStarted = true
        self.isDuckGenerating = false
        self.activateDuckGenerator()
        
        self.stageScene.removeAction(forKey: ActionKey.duckGeneratorTriggerWithDelay.key)
        self.stageScene.run(.sequence([
            .wait(forDuration: delay),
            .run
            {
                self.isDuckGenerating = true
            }
        ]), withKey: ActionKey.duckGeneratorTriggerWithDelay.key)
    }
    
    func startTargetGenerator(delay: Double = 0)
    {
        self.hasTargetGeneratorStarted = true
        self.isTargetGenerating = false
        self.activateTargetGenerator()
        
        self.stageScene.removeAction(forKey: ActionKey.targetGeneratorTriggerWithDelay.key)
        self.stageScene.run(.sequence([
            .wait(forDuration: delay),
            .run
            {
                self.isTargetGenerating = true
            }
        ]), withKey: ActionKey.targetGeneratorTriggerWithDelay.key)
    }
    
    func startBirdGenerator(delay: Double = 0)
    {
        self.hasBirdGeneratorStarted = true
        self.isBirdGenerating = false
        self.activateBirdGenerator()
        
        self.stageScene.removeAction(forKey: ActionKey.birdGeneratorTriggerWithDelay.key)
        self.stageScene.run(.sequence([
            .wait(forDuration: delay),
            .run
            {
                self.isBirdGenerating = true
            }
        ]), withKey: ActionKey.birdGeneratorTriggerWithDelay.key)
    }
    
    func startSwanGenerator(delay: Double = 0)
    {
        self.hasSwanGeneratorStarted = true
        self.isSwanGenerating = false
        self.activateSwanGenerator()
        
        self.stageScene.removeAction(forKey: ActionKey.swanGeneratorTriggerWithDelay.key)
        self.stageScene.run(.sequence([
            .wait(forDuration: delay),
            .run
            {
                self.isSwanGenerating = true
            }
        ]), withKey: ActionKey.swanGeneratorTriggerWithDelay.key)
    }
    
    func startAllGenerator(delay: Double = 0)
    {
        self.startDuckGenerator(delay: delay)
        self.startTargetGenerator(delay: delay)
        self.startBirdGenerator(delay: delay)
        self.startSwanGenerator(delay: delay)
    }
    
    //MARK: - Pause Generator
    func pauseDuckGenerator()
    {
        if self.hasDuckGeneratorStarted
        {
            self.isDuckGenerating = false
        }
    }
    
    func pauseTargetGenerator()
    {
        if self.hasTargetGeneratorStarted
        {
            self.isTargetGenerating = false
        }
    }
    
    func pauseBirdGenerator()
    {
        if self.hasBirdGeneratorStarted
        {
            self.isBirdGenerating = false
        }
    }
    
    func pauseSwanGenerator()
    {
        if self.hasSwanGeneratorStarted
        {
            self.isSwanGenerating = false
        }
    }
    
    func pauseAllGenerator()
    {
        self.pauseDuckGenerator()
        self.pauseTargetGenerator()
        self.pauseBirdGenerator()
        self.pauseSwanGenerator()
    }
    
    //MARK: - Continue Generator
    func continueDuckGenerator()
    {
        if self.hasDuckGeneratorStarted
        {
            self.isDuckGenerating = true
        }
    }
    
    func continueTargetGenerator()
    {
        if self.hasTargetGeneratorStarted
        {
            self.isTargetGenerating = true
        }
    }
    
    func continueBirdGenerator()
    {
        if self.hasBirdGeneratorStarted
        {
            self.isBirdGenerating = true
        }
    }
    
    func continueSwanGenerator()
    {
        if self.hasSwanGeneratorStarted
        {
            self.isSwanGenerating = true
        }
    }
    
    func continueAllGenerator()
    {
        self.continueDuckGenerator()
        self.continueTargetGenerator()
        self.continueBirdGenerator()
        self.continueSwanGenerator()
    }
    
    //MARK: - Restart Generator
    func restartDuckGenerator(delay: Double = 0)
    {
        if self.hasDuckGeneratorStarted
        {
            self.isDuckGenerating = false
            self._duckMoveDuration = self.duckMoveDuration
            self._duckMoveDurationOffset = self.duckMoveDurationOffset
            self._targetDuckMoveDuration = self.targetDuckMoveDuration
            self._targetDuckMoveDurationOffset = self.targetDuckMoveDurationOffset
            
            self.stageScene.removeAction(forKey: ActionKey.duckGeneratorTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isDuckGenerating = true
                }
            ]), withKey: ActionKey.duckGeneratorTriggerWithDelay.key)
        }
    }
    
    func restartTargetGenerator(delay: Double = 0)
    {
        if self.hasTargetGeneratorStarted
        {
            self.isTargetGenerating = false
            self._targetStayDuration = self.targetStayDuration
            self._targetStayDurationOffset = self.targetStayDurationOffset
            
            self.stageScene.removeAction(forKey: ActionKey.targetGeneratorTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isTargetGenerating = true
                }
            ]), withKey: ActionKey.targetGeneratorTriggerWithDelay.key)
        }
    }
    
    func restartBirdGenerator(delay: Double = 0)
    {
        if self.hasBirdGeneratorStarted
        {
            self.isBirdGenerating = false
            self._birdMoveDuration = self.birdMoveDuration
            self._birdMoveDurationOffset = self.birdMoveDurationOffset
            
            self.stageScene.removeAction(forKey: ActionKey.birdGeneratorTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isBirdGenerating = true
                }
            ]), withKey: ActionKey.birdGeneratorTriggerWithDelay.key)
        }
    }
    
    func restartSwanGenerator(delay: Double = 0)
    {
        if self.hasSwanGeneratorStarted
        {
            self.isSwanGenerating = false
            
            self.stageScene.removeAction(forKey: ActionKey.swanGeneratorTriggerWithDelay.key)
            self.stageScene.run(.sequence([
                .wait(forDuration: delay),
                .run
                {
                    self.isSwanGenerating = true
                }
            ]), withKey: ActionKey.swanGeneratorTriggerWithDelay.key)
        }
    }
    
    func restartAllGenerator(delay: Double = 0)
    {
        self.restartDuckGenerator(delay: delay)
        self.restartTargetGenerator(delay: delay)
        self.restartBirdGenerator(delay: delay)
        self.restartSwanGenerator(delay: delay)
    }
    
    //MARK: - Expire Generatoe
    func expireDuckGenerator()
    {
        if self.hasDuckGeneratorStarted
        {
            self.isDuckGenerating = false
            self.hasDuckGeneratorStarted = false
            self.duckGenerator?.invalidate()
        }
    }
    
    func expireTargetGenerator()
    {
        if self.hasTargetGeneratorStarted
        {
            self.isTargetGenerating = false
            self.hasTargetGeneratorStarted = false
            self.targetGenerator?.invalidate()
        }
    }
    
    func expireBirdGenerator()
    {
        if self.hasBirdGeneratorStarted
        {
            self.isBirdGenerating = false
            self.hasBirdGeneratorStarted = false
            self.birdGenerator?.invalidate()
        }
    }
    
    func expireSwanGenerator()
    {
        if self.hasSwanGeneratorStarted
        {
            self.isSwanGenerating = false
            self.hasSwanGeneratorStarted = false
            self.swanGenerator?.invalidate()
        }
    }
    
    func expireAllGenerator()
    {
        self.expireDuckGenerator()
        self.expireTargetGenerator()
        self.expireBirdGenerator()
        self.expireSwanGenerator()
    }
    
    //MARK: - Destroy Generated
    func destroyGeneratedDuck(withAnimation: Bool = false)
    {
        if withAnimation
        {
            for duck in self.generatedDuck
            {
                duck.restore()
                duck.run(.sequence([
                    .moveBy(x: 0, y: -200, duration: 3.5),
                    .run
                    {
                        duck.removeFromParent()
                        self.generatedDuck.remove(
                            at: self.generatedDuck.firstIndex(of: duck)!)
                    }
                ]))
            }
        }
        else
        {
            for duck in self.generatedDuck
            {
                duck.removeAllActions()
                duck.removeFromParent()
            }
            self.generatedDuck.removeAll()
        }
    }
    
    func destroyGeneratedTarget(withAnimation: Bool = false)
    {
        if withAnimation
        {
            for target in self.generatedTarget
            {
                target.restore()
                target.run(.sequence([
                    .moveBy(x: 0, y: -200, duration: 3.5),
                    .run
                    {
                        target.removeFromParent()
                        self.generatedTarget.remove(
                            at: self.generatedTarget.firstIndex(of: target)!)
                    }
                ]))
            }
        }
        else
        {
            for target in self.generatedTarget
            {
                target.removeAllActions()
                target.removeFromParent()
            }
            self.generatedTarget.removeAll()
        }
    }
    
    func destroyGeneratedBird(withAnimation: Bool = false)
    {
        if withAnimation
        {
            for bird in self.generatedBird
            {
                bird.restore()
                bird.run(.sequence([
                    .moveBy(x: 0, y: 200, duration: 3.5),
                    .run
                    {
                        bird.removeFromParent()
                        self.generatedBird.remove(
                            at: self.generatedBird.firstIndex(of: bird)!)
                    }
                ]))
            }
        }
        else
        {
            for bird in self.generatedBird
            {
                bird.removeAllActions()
                bird.removeFromParent()
            }
            self.generatedBird.removeAll()
        }
    }
    
    func destroyGeneratedSwan(withAnimation: Bool = false)
    {
        if withAnimation
        {
            for swan in self.generatedSwan
            {
                swan.restore()
                swan.run(.sequence([
                    .moveBy(x: 0, y: -200, duration: 3.5),
                    .run
                    {
                        swan.removeFromParent()
                        self.generatedSwan.remove(
                            at: self.generatedSwan.firstIndex(of: swan)!)
                    }
                ]))
            }
        }
        else
        {
            for swan in self.generatedSwan
            {
                swan.removeAllActions()
                swan.removeFromParent()
            }
            self.generatedSwan.removeAll()
        }
    }
    
    func destroyAllGenerated(withAnimation: Bool = false)
    {
        self.destroyGeneratedDuck(withAnimation: withAnimation)
        self.destroyGeneratedTarget(withAnimation: withAnimation)
        self.destroyGeneratedBird(withAnimation: withAnimation)
        self.destroyGeneratedSwan(withAnimation: withAnimation)
    }
}
