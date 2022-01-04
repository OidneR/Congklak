
import SpriteKit
import UIKit

struct CongklakHole {
    var congklakHole : SKSpriteNode
    var bijiCongklakCount : Int
    var congklakHoleOverlay : SKSpriteNode
    var bijiCongklak : [SKSpriteNode]
}


public class GameScene : SKScene{
    var papanCongklak : SKSpriteNode!
    var congklakHoles = [CongklakHole]()
    var playerHome : SKSpriteNode!
    var playerHomeCount : Int = 0
    var enemyHome :SKSpriteNode!
    var tappedHole : Int = -1
    var currentHoleIndex : Int = -1
    var waitDuration : Double = 0
    var isPlayerTurn : Bool = true
    var isComputerTurn : Bool = false
    var isOneLap : Bool = false
    var isPlayerAnimationRunning : Bool = false
    var isComputerAnimationRunning : Bool = false
    var label : SKLabelNode!
    var seedCount : [SKLabelNode] = []
    var isEndGame : Bool = false
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "backgroundTexture.png")))
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -100
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        papanCongklak = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "papan congklak.png")))// pakai papan congklak.png
        papanCongklak.zPosition = 0
        papanCongklak.position = CGPoint(x: frame.midX, y: frame.midY)
        label = SKLabelNode(fontNamed: "Chalkduster")
        addChild(label)
        addChild(papanCongklak)
        generateHole()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if(isPlayerTurn){
            label.text = "It's Your Turn, Pick Any Hole on your Side!"
            hideLabel(status: false)
            cekEmptyAll()
        }else if(isComputerTurn){
            label.text = "It's Computer Turn, Plase Wait"
            isOneLap = false
            var randomInt = Int.random(in: 8...14)
            var totalComputerSeedCount = 0
            for idx in 0...6{
                totalComputerSeedCount += congklakHoles[idx+8].bijiCongklakCount
            }
            if (totalComputerSeedCount > 0){
                while(congklakHoles[randomInt].bijiCongklakCount < 1 && isComputerTurn){
                    randomInt = Int.random(in: 8...14)
                    print(totalComputerSeedCount," ",randomInt)
                }
            }
            computerStartPlayAtIndex(index: randomInt)
            isComputerTurn = false
            self.isPlayerAnimationRunning = false
            self.isComputerAnimationRunning = true
        }else if(isPlayerAnimationRunning){
            label.text = "it's Your Turn, Moving Your Pieces"
            hideLabel(status: true)
        }else if(isComputerAnimationRunning){
            label.text = "Computer Moving It Pieces"
            hideLabel(status: true)
        }
        label.fontSize = 30
        let newY = 0.8 * (frame.maxY)
        label.position = CGPoint(x: frame.midX, y: newY)
        if(seedCount.count>0){
            setLabelStyle()
        }
        //cekEmptyAll()
    }
    func cekEmptyAll(){
        var totalPlayerSeedCount = 0
        var totalComputerSeedCount = 0
        for idx in 0...6{
            totalPlayerSeedCount += congklakHoles[idx].bijiCongklakCount
            totalComputerSeedCount += congklakHoles[idx+8].bijiCongklakCount
        }
        if(totalPlayerSeedCount+totalComputerSeedCount == 0){
            isEndGame = true
        }else if (totalPlayerSeedCount == 0){
            isPlayerTurn = false
            isComputerTurn = true
        }else if (totalComputerSeedCount == 0){
            isComputerTurn = false
            isPlayerTurn = true
        }
        if(isEndGame){
            waitDuration+=2
            self.printEndGame()
            for i in seedCount{
                i.isHidden = true 
            }
        }
    }
    func setLabelStyle(){
        for i in 1...seedCount.count{
            
            let tempLabel = seedCount[i-1]
            tempLabel.fontSize = 30
            if i == 8{
                tempLabel.text = "Player Home Has \(congklakHoles[i-1].bijiCongklakCount) Seed"
                tempLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            }else if i == 16{
                tempLabel.text = "Enemy Home Has \(congklakHoles[i-1].bijiCongklakCount) Seed"
                tempLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            }else{
                
                tempLabel.text = "\(congklakHoles[i-1].bijiCongklakCount)"
                
            }
            
        }
    }
    func hideLabel(status : Bool){
        for label in seedCount{
            label.isHidden = status
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            let node : SKNode = self.atPoint(loc)
            for i in 0 ... 14 {
                if congklakHoles[i].congklakHoleOverlay.name == node.name {
                    tappedHole = i
                    break
                }else{
                    tappedHole = -1
                }
            }
        }
        if (tappedHole <= 6 && isPlayerTurn){
            if(congklakHoles[tappedHole].bijiCongklakCount>0){
                isPlayerTurn = false
                isPlayerAnimationRunning = true
                isComputerAnimationRunning = false
                isOneLap = false
                playerStartPlayAtIndex(index: tappedHole)
            }
            
        }
    }
    func generateHole(){
        var index = 0
        var bijiId = 1000
        for i in -3 ... 3{
            var congklakHoleNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "TeritoryHole.png")))//teritoryHole.png
            var congklakHoleOverlayNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "TeritoryHole.png")))//teritoryHole.png
            var arrayOfBijiCongklak : [SKSpriteNode] = []
            //  buat 7 biji congklak
            for i in 1...7{
                var bijiCongklakNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "bijiCongklak.png")))//bijiCongklak.png
                bijiCongklakNode.zPosition = 2
                bijiCongklakNode.name = String(bijiId)
                bijiId+=1
                addChild(bijiCongklakNode)
                arrayOfBijiCongklak.append(bijiCongklakNode)
            }
            var spawnY = papanCongklak.size.height/4
            // buat lubang
            let congklakHoleInstance = CongklakHole(congklakHole: congklakHoleNode, bijiCongklakCount: 7, congklakHoleOverlay: congklakHoleOverlayNode, bijiCongklak: arrayOfBijiCongklak)
            //positioning
            var spawnX = CGFloat(i)*(congklakHoleInstance.congklakHole.size.width)*1.2
            congklakHoleInstance.congklakHoleOverlay.name = String(index) 
            congklakHoleInstance.congklakHole.position = CGPoint(x: frame.midX-spawnX, y: frame.midY-spawnY)
            congklakHoleInstance.congklakHoleOverlay.alpha = 0.000001
            congklakHoleInstance.congklakHoleOverlay.zPosition = 100
            congklakHoleInstance.congklakHoleOverlay.position = congklakHoleInstance.congklakHole.position
            print(congklakHoleInstance.congklakHoleOverlay.position)
            congklakHoleInstance.congklakHole.zPosition = 1
            addChild(congklakHoleInstance.congklakHole)
            addChild(congklakHoleInstance.congklakHoleOverlay)
            congklakHoles.append(congklakHoleInstance)
            for biji in arrayOfBijiCongklak  {
                var lobangCongklakWidth = (congklakHoleNode.size.width*0.1)
                var bijiXPos = Float.random( in: -1...1) 
                var bijiYPos = Float.random(in: -1...1)
                biji.position = CGPoint(x: congklakHoleNode.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoleNode.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            }
            // buat label counter
            var tempLabel = SKLabelNode(fontNamed: "Chalkduster")
            tempLabel.position = CGPoint(x: frame.midX-spawnX, y: frame.midY-papanCongklak.size.height)
            seedCount.append(tempLabel)
            addChild(tempLabel)
            index += 1
        }
        playerHome = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "HomeHole.png")))//HomeHole.png
        let playerHomeOverlay = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "HomeHole.png")))//HomeHole.png
        let playerHomeNode = CongklakHole(congklakHole: playerHome, bijiCongklakCount: 0, congklakHoleOverlay: playerHomeOverlay, bijiCongklak: [])
        playerHome.zPosition = 1
        var playerHomeXPos = playerHome.size.width*3.2
        playerHomeNode.congklakHole.position = CGPoint(x: frame.midX-playerHomeXPos, y: frame.midY)
        addChild(playerHomeNode.congklakHole)
        congklakHoles.append(playerHomeNode)
        var tempLabel1 = SKLabelNode(fontNamed: "Chalkduster")
        tempLabel1.position = CGPoint(x: frame.midX-playerHomeXPos-100, y: frame.midY)
        seedCount.append(tempLabel1)
        addChild(tempLabel1)
        for i in -3 ... 3{
            var congklakHoleNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "TeritoryHole.png")))//teritoriHole.png
            var congklakHoleOverlayNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "TeritoryHole.png")))//teritoryHole.png
            var arrayOfBijiCongklak : [SKSpriteNode] = []
            // spawn 7 biji congklak
            for j in 1...7{
                var bijiCongklakNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "bijiCongklak.png")))//bijicongklak.png
                bijiCongklakNode.zPosition = 2
                bijiCongklakNode.name = String(bijiId)
                bijiId+=1
                var lobangCongklakWidth = (congklakHoleNode.size.width*0.1)
                var bijiXPos = Float.random( in: -1...1) 
                var bijiYPos = Float.random(in: -1...1)
                bijiCongklakNode.position = CGPoint(x: congklakHoleNode.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoleNode.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
                addChild(bijiCongklakNode)
                arrayOfBijiCongklak.append(bijiCongklakNode)
            }
            //buat lubang biji congklak
            let congklakHoleInstance = CongklakHole(congklakHole: congklakHoleNode, bijiCongklakCount: 7, congklakHoleOverlay: congklakHoleOverlayNode, bijiCongklak: arrayOfBijiCongklak)
            //positioning
            var spawnY = papanCongklak.size.height/4
            var spawnX = CGFloat(i)*(congklakHoleInstance.congklakHole.size.width) * 1.2
            congklakHoleInstance.congklakHole.position = CGPoint(x: frame.midX+spawnX, y: frame.midY+spawnY)
            print(papanCongklak.size)
            congklakHoleInstance.congklakHoleOverlay.name = String(index)
            congklakHoleInstance.congklakHoleOverlay.alpha = 0.000001
            congklakHoleInstance.congklakHoleOverlay.zPosition = 100
            congklakHoleInstance.congklakHoleOverlay.position = congklakHoleInstance.congklakHole.position
            congklakHoleInstance.congklakHole.zPosition = 1
            addChild(congklakHoleInstance.congklakHole)
            addChild(congklakHoleInstance.congklakHoleOverlay)
            congklakHoles.append(congklakHoleInstance)
            for biji in arrayOfBijiCongklak  {
                var lobangCongklakWidth = (congklakHoleNode.size.width*0.1)
                var bijiXPos = Float.random( in: -1...1) 
                var bijiYPos = Float.random(in: -1...1)
                biji.position = CGPoint(x: congklakHoleNode.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoleNode.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            }
            var tempLabel = SKLabelNode(fontNamed: "Chalkduster")
            tempLabel.position = CGPoint(x: frame.midX+spawnX, y: frame.midY+papanCongklak.size.height)
            seedCount.append(tempLabel)
            addChild(tempLabel)
            index += 1
        }
        
        enemyHome = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "HomeHole.png")))//HomeHole.png
        let enemyHomeOverlay = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "HomeHole.png")))//HomeHole.png
        let enemyHomeNode = CongklakHole(congklakHole: enemyHome, bijiCongklakCount: 0, congklakHoleOverlay: enemyHomeOverlay, bijiCongklak: [])
        enemyHome.zPosition = 1
        enemyHomeNode.congklakHole.position = CGPoint(x: frame.midX+playerHomeXPos, y: frame.midY)
        addChild(enemyHomeNode.congklakHole)
        congklakHoles.append(enemyHomeNode)
        var tempLabel2 = SKLabelNode(fontNamed: "Chalkduster")
        tempLabel2.position = CGPoint(x: frame.midX+playerHomeXPos+100, y: frame.midY)
        seedCount.append(tempLabel2)
        addChild(tempLabel2)
    }
    
    func printAllHole(){
        for a in congklakHoles{
            print(a.congklakHoleOverlay.name,"has",a.bijiCongklak.count,a.bijiCongklakCount)
        }
        for a in congklakHoles[3].bijiCongklak{
            print(a.name)
        }
    }
    func printEndGame(){
        if(congklakHoles[7].bijiCongklakCount > congklakHoles[15].bijiCongklakCount){
            label.text = "You Win With \(congklakHoles[7].bijiCongklakCount) Seeds on Your Home"
        }else if(congklakHoles[7].bijiCongklakCount ==  congklakHoles[15].bijiCongklakCount){
            label.text = "You Draw With \(congklakHoles[7].bijiCongklakCount) Seeds on Your Home"
        }else{ 
            label.text = "You Lose With \(congklakHoles[15].bijiCongklakCount) Seeds on Your Enemy's Home"
        }
        
    }
    //Player
    func moveBijiCongklaktoHand(index: Int){
        var idx : CGFloat = 1
        for biji in 1...congklakHoles[index].bijiCongklakCount{
            waitDuration += 0.25
            let totalBiji = congklakHoles[index].bijiCongklak.count
            let wait = SKAction.wait(forDuration: Double(waitDuration))
            let tempBijiCongklak = congklakHoles[index].bijiCongklak[totalBiji-biji]
            var a = (tempBijiCongklak.size.width * idx * 2.0)
            var moveToPoint = CGPoint(x: frame.midX-(0.1*frame.width)+a, y: frame.midY-(0.1*frame.height))
            tempBijiCongklak.zPosition = 2
            let move = SKAction.move(to: moveToPoint, duration: 0.25)
            tempBijiCongklak.run(SKAction.sequence([wait,move]))
            idx += 1
        }
    }
    func moveTheBijiCongklak(index :Int){
        var currentHole = index
        var numOfBiji = congklakHoles[index].bijiCongklakCount
        congklakHoles[index].bijiCongklakCount = 0
        let totalBiji = congklakHoles[index].bijiCongklak.count
        for indexBiji in 1...numOfBiji{
            waitDuration += 0.25
            let waitFor = SKAction.wait(forDuration: Double(waitDuration))
            currentHole+=1
            if(currentHole == 15){
                currentHole = 0
            }
            congklakHoles[currentHole].bijiCongklakCount+=1
                //randomize moveTo location
            var lobangCongklakWidth = (congklakHoles[currentHole].congklakHole.size.width*0.1)
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[currentHole].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[currentHole].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
                //move bijinya
            
                // gerakin biji 1 per 1
            let moveBiji = SKAction.move(to: movePosition, duration: 0.25)
            let tempWait = SKAction.wait(forDuration: 1.1)
            let appendPop = SKAction.run {
                
            }
            congklakHoles[index].bijiCongklak[totalBiji-indexBiji].run(SKAction.sequence([waitFor ,moveBiji,appendPop]))
            var tempBiji2 = self.congklakHoles[index].bijiCongklak[totalBiji-indexBiji] 
            self.congklakHoles[currentHole].bijiCongklak.append(tempBiji2)
            if currentHole == tappedHole{
                isOneLap = true
            }
        }
        
        currentHoleIndex = currentHole
    }
    func playerStartPlayAtIndex(index :Int){
        var idx = index
        var currentHoleBijiCount = congklakHoles[index].bijiCongklakCount + 1
        while currentHoleBijiCount > 1 && idx != 7{
            moveBijiCongklaktoHand(index: idx)
            moveTheBijiCongklak(index: idx)
            idx = currentHoleIndex
            currentHoleBijiCount = congklakHoles[idx].bijiCongklakCount
        }
        
        
        
        if(idx==7){
            let checkAllEmpty = SKAction.run{
                self.cekEmptyAll()
            }
            let setPlayerStatus = SKAction.run {
                self.isPlayerTurn = true
            }
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus,checkAllEmpty]))
        }else if(idx<=6 && idx>=0){
            if(isOneLap){
                getAllACross(index: idx)
            }
            let setPlayerStatus = SKAction.run {
                self.isPlayerTurn = false
                self.isComputerTurn = true
                self.isPlayerAnimationRunning = false
                self.isComputerAnimationRunning = false
            }
            
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus]))
            
        }else if(isEndGame){
            waitDuration+=2
            let wait = SKAction.wait(forDuration: waitDuration)
            let printEndgame = SKAction.run{
                self.printEndGame()
            }
            self.run(SKAction.sequence([wait,printEndgame]))
        }
        else{
            let setPlayerStatus = SKAction.run {
                self.isPlayerTurn = false
                self.isComputerTurn = true
                self.isPlayerAnimationRunning = false
                self.isComputerAnimationRunning = false
            }
            
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus]))
        }
        
        waitDuration = 0
        
    }
    
    func getAllACross(index :Int){
        waitDuration+=1
        let wait = SKAction.wait(forDuration: waitDuration)
        var lobangCongklakWidth = (congklakHoles[7].congklakHole.size.width*0.1)
        if(congklakHoles[index].bijiCongklakCount>0 && congklakHoles[14-index].bijiCongklakCount>0){
        for indexBiji in 1...congklakHoles[index].bijiCongklakCount{
            let totalBiji = congklakHoles[index].bijiCongklak.count
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[7].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[7].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            let moveTo = SKAction.move(to: movePosition, duration: 1)
            let a = congklakHoles[index].bijiCongklak[totalBiji-indexBiji]
            a.run(SKAction.sequence([wait,moveTo]))
            congklakHoles[index].bijiCongklakCount = 0
            congklakHoles[7].bijiCongklakCount+=1
            congklakHoles[7].bijiCongklak.append(a)
        }
        for indexBiji in 1...congklakHoles[14-index].bijiCongklakCount{
            let totalBiji = congklakHoles[14-index].bijiCongklak.count
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[7].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[7].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            let moveTo = SKAction.move(to: movePosition, duration: 1)
            let a = congklakHoles[14-index].bijiCongklak[totalBiji-indexBiji]
            a.run(SKAction.sequence([wait,moveTo]))
            congklakHoles[14-index].bijiCongklakCount=0
            congklakHoles[7].bijiCongklakCount+=1
            congklakHoles[7].bijiCongklak.append(a)
        }
        }
    }
    //Computer
    func moveBijiCongklaktoComputerHand(index: Int){
        var idx : CGFloat = 1
        for biji in 1...congklakHoles[index].bijiCongklakCount{
            waitDuration += 0.25
            let totalBiji = congklakHoles[index].bijiCongklak.count
            let wait = SKAction.wait(forDuration: Double(waitDuration))
            let tempBijiCongklak = congklakHoles[index].bijiCongklak[totalBiji-biji]
            var a = (tempBijiCongklak.size.width * idx * 2.0)
            var moveToPoint = CGPoint(x: frame.midX-(0.1*frame.width)+a, y: frame.midY+(0.1*frame.height))
            tempBijiCongklak.zPosition = 2
            let move = SKAction.move(to: moveToPoint, duration: 0.25)
            tempBijiCongklak.run(SKAction.sequence([wait,move]))
            idx += 1
        }
    }
    func computerMoveTheBijiCongklak(index :Int){
        var currentHole = index
        var numOfBiji = congklakHoles[index].bijiCongklakCount
        congklakHoles[index].bijiCongklakCount = 0
        let totalBiji = congklakHoles[index].bijiCongklak.count
        for var indexBiji in 1...numOfBiji{
            waitDuration += 0.25
            let waitFor = SKAction.wait(forDuration: Double(waitDuration))
            currentHole+=1
            if(currentHole == 7){
                currentHole = 8
            }
            if(currentHole == 16){
                currentHole = 0
            }
            congklakHoles[currentHole].bijiCongklakCount+=1
            //randomize moveTo location
            var lobangCongklakWidth = (congklakHoles[currentHole].congklakHole.size.width*0.1)
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[currentHole].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[currentHole].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            //move bijinya
            
            // gerakin biji 1 per 1
            let moveBiji = SKAction.move(to: movePosition, duration: 0.25)
            let tempWait = SKAction.wait(forDuration: 1.1)
            let appendPop = SKAction.run {
                
            }
            
            
            congklakHoles[index].bijiCongklak[totalBiji-indexBiji].run(SKAction.sequence([waitFor ,moveBiji,appendPop]))
            var tempBiji2 = self.congklakHoles[index].bijiCongklak[totalBiji-indexBiji] 
            self.congklakHoles[currentHole].bijiCongklak.append(tempBiji2)
            
            
            if currentHole == tappedHole{
                isOneLap = true
            }
        }
        
        currentHoleIndex = currentHole
    }
    func computerStartPlayAtIndex(index :Int){
        var idx = index
        var currentHoleBijiCount = congklakHoles[index].bijiCongklakCount + 1
        while currentHoleBijiCount > 1 && idx != 15{
            moveBijiCongklaktoComputerHand(index: idx)
            computerMoveTheBijiCongklak(index: idx)
            idx = currentHoleIndex
            currentHoleBijiCount = congklakHoles[idx].bijiCongklakCount
        }
        
        
        
        if(idx==15){
            let checkAllEmpty = SKAction.run{
                self.cekEmptyAll()
            }
            let setPlayerStatus = SKAction.run {
                self.isComputerTurn = true
            }
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus,checkAllEmpty]))
        }else if(idx<=14 && idx>=8){
            if(isOneLap){
                computerGetAllACross(index: idx)
            }
            let setPlayerStatus = SKAction.run {
                self.isPlayerTurn = true
                self.isComputerTurn = false
                self.isPlayerAnimationRunning = false
                self.isComputerAnimationRunning = false
            }
            
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus]))
            
        }else if(isEndGame){
            waitDuration+=2
            let wait = SKAction.wait(forDuration: waitDuration)
            let printEndgame = SKAction.run{
                self.printEndGame()
            }
            self.run(SKAction.sequence([wait,printEndgame]))
        }else{
            let setPlayerStatus = SKAction.run {
                self.isPlayerTurn = true
                self.isComputerTurn = false
                self.isPlayerAnimationRunning = false
                self.isComputerAnimationRunning = false
            }
            
            let wait = SKAction.wait(forDuration: waitDuration)
            self.run(SKAction.sequence([wait,setPlayerStatus]))
        }
        for var i in congklakHoles{
            let tempInt = i.bijiCongklak.count-i.bijiCongklakCount
            if(tempInt>=1){
                for a in 0...tempInt-1{
                    i.bijiCongklak.remove(at: 0)
                }
            }
//              while(i.bijiCongklakCount != i.bijiCongklak.count ){
//                  
//              }
        }
        waitDuration = 0
        
    }
    
    func computerGetAllACross(index :Int){
        waitDuration+=1
        let wait = SKAction.wait(forDuration: waitDuration)
        var lobangCongklakWidth = (congklakHoles[15].congklakHole.size.width*0.1)
        if(congklakHoles[index].bijiCongklakCount>0 && congklakHoles[14-index].bijiCongklakCount>0){
        for indexBiji in 1...congklakHoles[index].bijiCongklakCount{
            let totalBiji = congklakHoles[index].bijiCongklak.count
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[15].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[15].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            let moveTo = SKAction.move(to: movePosition, duration: 1)
            let a = congklakHoles[index].bijiCongklak[totalBiji-indexBiji]
            a.run(SKAction.sequence([wait,moveTo]))
            congklakHoles[index].bijiCongklakCount = 0
            congklakHoles[15].bijiCongklakCount+=1
            congklakHoles[15].bijiCongklak.append(a)
        }
        for indexBiji in 1...congklakHoles[14-index].bijiCongklakCount{
            let totalBiji = congklakHoles[14-index].bijiCongklak.count
            var bijiXPos = Float.random( in: -1...1) 
            var bijiYPos = Float.random(in: -1...1)
            var movePosition = CGPoint(x: congklakHoles[15].congklakHole.frame.midX + (CGFloat(bijiXPos)*lobangCongklakWidth), y: congklakHoles[15].congklakHole.frame.midY + (CGFloat(bijiYPos)*lobangCongklakWidth))
            let moveTo = SKAction.move(to: movePosition, duration: 1)
            let a = congklakHoles[14-index].bijiCongklak[totalBiji-indexBiji]
            a.run(SKAction.sequence([wait,moveTo]))
            congklakHoles[14-index].bijiCongklakCount=0
            congklakHoles[15].bijiCongklakCount+=1
            congklakHoles[15].bijiCongklak.append(a)
        }}
        
    }
    
    
}
