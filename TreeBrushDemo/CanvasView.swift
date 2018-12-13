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
        let x = Double(origin.x) + cos(angle * Double.pi/180.0) * length * 4
        let y = Double(origin.y) + sin(angle * Double.pi/180.0) * length * 4
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
    var treeDepth:Int = 13
    var totalNodeLimit = 0
    
    var nodeCounter = 1
    var currentLevel: [TreeNode]?
    var currentDepth = 0
    var colorCounter = 0
    var numberOfNodesToDraw = 1
    
    var userIsTouchingScreen = false
    var displayLink: CADisplayLink?
    
    var animation: CABasicAnimation?
    var animationIsPlaying = false
    
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
        context?.clear(CGRect(x: 0, y: 0, width: self.bounds.width * UIScreen.main.scale , height: self.bounds.height * UIScreen.main.scale))
        self.layer.removeAllAnimations()
        self.layer.sublayers?.removeAll()
        self.image = UIImage(cgImage: context.makeImage()!)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCGContext()
        setupDisplayLink()
        setupFirstLevel()
        setupAnimation()
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
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.closePath()
        context.strokePath()
    }
    
    
    //level by level growth. Also slow by the end.
    func drawLevel(){
        if currentDepth == 0 {
            currentLevel?.removeAll()
            return
        }
        if !animationIsPlaying {
            CATransaction.begin()
            animationIsPlaying = true
            CATransaction.setCompletionBlock {
                self.layer.removeAllAnimations()
                self.layer.sublayers?.removeAll()
                self.animationIsPlaying = false
                if let levelImage = self.context.makeImage(){
                    self.image = UIImage(cgImage: levelImage)
                }
                self.drawLevel()
            }
            var nextLevel = [TreeNode]()
            if let currentTreeLevel = currentLevel {
                
                context.setLineWidth(CGFloat(Double(currentDepth) / 5.0))
                let branchColor = UIColor(hue: CGFloat(Double(currentDepth) / Double(treeDepth)), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
                context.setStrokeColor(branchColor)
                
                for node in currentTreeLevel{
                    drawLine(fromPoint: node.origin, toPoint: node.endPoint)
                    let varyLeftAngle = Int.random(in: -20...20)
                    let leftChild = TreeNode(origin: node.endPoint, angle: node.angle - self.leftAngle + Double(varyLeftAngle), length: Double(currentDepth))
                    let varyRightAngle = Int.random(in: -20...20)
                    let rightChild = TreeNode(origin: node.endPoint, angle: node.angle + self.rightAngle + Double(varyRightAngle), length: Double(currentDepth))
                    nextLevel.append(leftChild)
                    nextLevel.append(rightChild)
                    
                    setupShapeLayer(node: node, depth: currentDepth, color: branchColor)
                }
                currentLevel = nextLevel
                currentDepth -= 1
            }
            CATransaction.commit()
        }
        
    }
    
    
    func setupAnimation(){
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation?.fromValue = 0.0
        animation?.toValue = 1.0
        animation?.duration = 1.0
        animation?.repeatCount = 0
    }
    
    
    
    //add a single line animation and CAShapeLayer to the view's layer
    func setupShapeLayer(node: TreeNode, depth: Int, color: CGColor){
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = setupBezierPath(start: node.origin, end: node.endPoint).cgPath
        lineLayer.strokeColor = color
        lineLayer.lineWidth = CGFloat(depth) / 5.0
        lineLayer.add(animation ?? CABasicAnimation(keyPath: "strokeEnd"), forKey: "drawLineAnimation")
        self.layer.addSublayer(lineLayer)
    }
    
    func setupBezierPath(start: CGPoint, end: CGPoint) -> UIBezierPath {
        
        let path = UIBezierPath()
        //very tricky: Core Animation's y axis is flipped compared with Core Graphics context, so we must 'unflip' to get the proper view
        path.move(to: CGPoint(x: start.x, y: self.bounds.height - start.y))
        path.addLine(to: CGPoint(x: end.x, y: self.bounds.height - end.y))
        path.close()
        
        return path
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
