

import SpriteKit
import UIKit
import PlaygroundSupport

public class Introduction : SKScene {
    var titleLabel : SKLabelNode!
    var titleSimpleDesc : [SKLabelNode]! = []
    var tapAnyWhereToContinue : SKLabelNode!
    
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "backgroundTexture.png")))
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -100
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        //set Title
        titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.fontSize = 50
        titleLabel.text = "CONGKLAK"
        titleLabel.fontColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY*0.9)
        addChild(titleLabel)
        //set title Simple Desc
        for i in 0...7{
            let titleSimpleDescInstance = SKLabelNode(fontNamed: "Chalkduster")
            titleSimpleDescInstance.fontSize = 25
            titleSimpleDescInstance.fontColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            if (i==0){
                titleSimpleDescInstance.text = "Congklak is a traditional game from Indonesia."
            }else if(i==1){
                titleSimpleDescInstance.text = "Congklak Usually Played by Indonesian Children."
            }else if(i==2){
                titleSimpleDescInstance.text = "Congklak Used for sharpen their Counting Skill."
            }else if(i==3){
                titleSimpleDescInstance.text = "Due To increased number of phone used by children."
            }else if (i==4){
                titleSimpleDescInstance.text = "Traditional Game like Congklak soon will be forgotten."
            }else if(i==5){
                titleSimpleDescInstance.text = "That's Why I make this playground, beside for reintroducing"
            }else if (i==6){
                titleSimpleDescInstance.text = "this traditional game to Indonesian Kid, "
            }else if (i==7){
                titleSimpleDescInstance.text = "this playground will teach anyone how to play it"
            }
            titleSimpleDescInstance.numberOfLines = 2
            titleSimpleDescInstance.preferredMaxLayoutWidth = frame.maxX*0.8
            titleSimpleDescInstance.position = CGPoint(x: frame.midX, y: frame.maxY*0.8-CGFloat(i*30))
            addChild(titleSimpleDescInstance)
            titleSimpleDesc.append(titleSimpleDescInstance)
        }
        // anywhere to continue
        tapAnyWhereToContinue = SKLabelNode(fontNamed: "Chalkduster")
        tapAnyWhereToContinue.fontSize = 25
        tapAnyWhereToContinue.text = "Tap Any Where To Continue"
        tapAnyWhereToContinue.fontColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        tapAnyWhereToContinue.position = CGPoint(x: frame.midX, y: frame.maxY*0.2)
        addChild(tapAnyWhereToContinue)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let spriteKitView = SKView(frame: .zero)
            let gameScene = MainMenuScene(size: UIScreen.main.bounds.size)
            gameScene.scaleMode = .aspectFill
            spriteKitView.presentScene(gameScene)
            PlaygroundPage.current.liveView = spriteKitView
            PlaygroundPage.current.wantsFullScreenLiveView = true
    }
}


