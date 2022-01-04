


import SpriteKit
import PlaygroundSupport
import UIKit
let spriteKitView = SKView(frame: .zero)
let gameScene = Introduction(size: UIScreen.main.bounds.size)
gameScene.scaleMode = .aspectFill

spriteKitView.presentScene(gameScene)

PlaygroundPage.current.liveView = spriteKitView
PlaygroundPage.current.wantsFullScreenLiveView = true
