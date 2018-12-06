//
//  CanvasView.swift
//  TreeFractal2Demo
//
//  Created by Jerry Wang on 11/17/18.
//  Copyright © 2018 Jerry Wang. All rights reserved.
//

import UIKit

struct TreeNode {
    var origin: CGPoint
    var angle: Double
    var length: Double
    var endPoint: CGPoint {
        let x = Double(origin.x) + cos(angle * Double.pi/180.0) * length * 2
        let y = Double(origin.y) + sin(angle * Double.pi/180.0) * length * 2
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    init(origin: CGPoint, angle: Double, length: Double){
        self.origin = origin
        self.angle = angle
        self.length = length
    }
}

class CanvasView: UIImageView{
    
    var context: CGContext!
    
    
    var leftAngle:Double = 15
    var rightAngle:Double = 15
    var treeDepth:Int = 17
    var totalNodeLimit = 0
    
    var nodeCounter = 1
    var currentLevel: [TreeNode]?
    var currentDepth = 0
    var colorCounter = 0
    var numberOfNodesToDraw = 1
    
    var userIsTouchingScreen = false
    var displayLink: CADisplayLink?
    
    func setupCGContext(){
        
        context = CGContext(data: nil,
                            width: Int(self.bounds.width * UIScreen.main.scale),
                            height: Int(self.bounds.height * UIScreen.main.scale),
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        fillScreenToBlack()
        context?.scaleBy(x: UIScreen.main.scale, y: UIScreen.main.scale)
    }
    
    func fillScreenToBlack(){
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: self.bounds.width * UIScreen.main.scale , height: self.bounds.height * UIScreen.main.scale))
        
        self.image = UIImage(cgImage: context.makeImage()!)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCGContext()
        setupDisplayLink()
        setupFirstLevel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(){
        setupFirstLevel()
        fillScreenToBlack()
    }
    
    func setupDisplayLink(){
        displayLink = CADisplayLink(target: self, selector: #selector(drawVariableTreeNodes))
        displayLink?.preferredFramesPerSecond = 30
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    
    func setupFirstLevel(){
        let root = TreeNode(origin: CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height / 5), angle: Double(Int.random(in: 75...105)), length: Double(self.treeDepth))
        currentLevel = [root]
        currentDepth = treeDepth
        totalNodeLimit = (2 << treeDepth) - 1
        nodeCounter = 1
        numberOfNodesToDraw = 1
        
    }
    
    @objc func drawVariableTreeNodes(){
        
        if currentDepth < 1 {
            return
        }
        if userIsTouchingScreen{
            for _ in 0...numberOfNodesToDraw {
                drawSingleTreeNode()
            }
            if let levelImage = context.makeImage(){
                self.image = UIImage(cgImage: levelImage)
            } else {
                print("failed! \(nodeCounter)")
            }
            
        }
    }
    
    func drawSingleTreeNode(){
        let positiveDepth = treeDepth - currentDepth
        let nodeLimitForLevel = (2 << positiveDepth) - 1
        //if we've reached the max number of nodes in the binary tree, we should no longer draw any more
        if nodeCounter >= totalNodeLimit { return }
        //if the node limit for the current level has been reached, we should start a new level.
        if nodeCounter >= Int(nodeLimitForLevel) {
            currentDepth -= 1
            numberOfNodesToDraw = nodeLimitForLevel / 40 < 500 ? (nodeLimitForLevel / 40) + 1 : 500
        }
        
        colorCounter += 1
        colorCounter %= 100
        let colorValue = (Double(currentDepth) / Double(treeDepth)) + Double(colorCounter) / 1000.0
        context.setLineWidth(CGFloat(Double(currentDepth) / 5.0))
        context.setStrokeColor(UIColor(hue: CGFloat(colorValue), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
        
        //if there is a node in the current queue: remove it , render it, and add 2 children to the queue and the counter.
        if let currentNode = currentLevel?.removeFirst() {
            drawLine(fromPoint: currentNode.origin, toPoint: currentNode.endPoint)
            
            let varyLeftAngle = Int.random(in: -30...30)
            let leftChild = TreeNode(origin: currentNode.endPoint, angle: currentNode.angle - self.leftAngle + Double(varyLeftAngle), length: Double(currentDepth))
            let varyRightAngle = Int.random(in: -30...30)
            let rightChild = TreeNode(origin: currentNode.endPoint, angle: currentNode.angle + self.rightAngle + Double(varyRightAngle), length: Double(currentDepth))
            
            currentLevel?.append(leftChild)
            currentLevel?.append(rightChild)
            nodeCounter += 2
        }
    }
    
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){
//        print(fromPoint,toPoint)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.closePath()
        context.strokePath()
    }
}



extension CanvasView: ScrollViewTouchDelegate {
    func UserTouchedScrollView() {
        self.userIsTouchingScreen = true
    }
    
    func UserStoppedTouchingScrollView() {
        self.userIsTouchingScreen = false
    }
}
