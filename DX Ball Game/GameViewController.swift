//
//  GameViewController.swift
//  DX Ball Game
//
//  Created by Fazle Rabbi Linkon on 21/7/20.
//  Copyright © 2020 Fazle Rabbi Linkon. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView?
        
        if skView != nil {
            
            skView!.showsFPS = true
            skView!.showsNodeCount = true
            
            let gameScene = GameScene(size: (skView?.bounds.size)!)
            gameScene.scaleMode = SKSceneScaleMode.aspectFill
            
            skView?.presentScene(gameScene)
            
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
