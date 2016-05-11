//
//  GameScene.swift
//  PanicTrainDemo
//
//  Created by Quang Huynh on 4/28/16.
//  Copyright (c) 2016 Quang Huynh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Our main scene. Everything is added to this for the playable game
    var moving: SKNode!
    
    // Our running man! Defaults to a stand still position
    let heroAtlas = SKTextureAtlas(named: "Player.atlas")
    var hero: SKSpriteNode!
    
    override func didMoveToView(view: SKView)
    {
        // setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -3)
        
        moving = SKNode()
        self.addChild(moving)
        
        createSky()
        createGround()
        
        hero = SKSpriteNode(texture: heroAtlas.textureNamed("Run_01"))
        hero.position = CGPointMake(frame.width / 8, frame.height / 2)
        
        // Enable physics around our hero using a circle to draw our radius
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.height / 2)
        hero.physicsBody!.dynamic = true
        
        self.addChild(hero)
        runForward()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches
        {
            // Do jump
            let hero_jump_anim = SKAction.animateWithTextures([
                heroAtlas.textureNamed("Jump_01"),
                heroAtlas.textureNamed("Jump_02"),
                heroAtlas.textureNamed("Jump_03"),
                heroAtlas.textureNamed("Jump_04"),
                heroAtlas.textureNamed("Jump_05"),
                heroAtlas.textureNamed("Jump_06")
                ], timePerFrame: 0.25)
            
            let jump = SKAction.repeatAction(hero_jump_anim, count: 1)
            
            if (hero.actionForKey("jumping") == nil)
            {
                hero.runAction(jump, withKey: "jumping")
                hero.physicsBody!.velocity = CGVectorMake(0, 0)
                hero.physicsBody!.applyImpulse(CGVectorMake(0, 100))
            }
        }
    }
    
    func runForward()
    {
        let hero_run_anim = SKAction.animateWithTextures([
            heroAtlas.textureNamed("Run_01"),
            heroAtlas.textureNamed("Run_02"),
            heroAtlas.textureNamed("Run_03"),
            heroAtlas.textureNamed("Run_04"),
            heroAtlas.textureNamed("Run_05"),
            heroAtlas.textureNamed("Run_06")
            ], timePerFrame: 0.1)
        
        let run = SKAction.repeatActionForever(hero_run_anim)
        
        hero.runAction(run, withKey: "running")
    }
    
    func createGround()
    {
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = .Nearest
        
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.01 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / (groundTexture.size().width * 2.0); ++i
        {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: groundTexture.size().width, height: groundTexture.size().height))
            sprite.physicsBody!.dynamic = false
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
    }
    
    func createSky()
    {
        let skyTexture = SKSpriteNode(color: UIColor(red: 71/255, green: 140/255, blue: 183/255, alpha: 1.0), size: frame.size)
        skyTexture.position = CGPointMake(frame.width / 2, frame.height / 2)
        moving.addChild(skyTexture)
    }
    
}
