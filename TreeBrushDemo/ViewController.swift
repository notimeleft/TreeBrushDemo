//
//  ViewController.swift
//  TreeFractal2Demo
//
//  Created by Jerry Wang on 11/15/18.
//  Copyright © 2018 Jerry Wang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var scrollView: CustomScrollView!
    var canvasView: CanvasView!
    var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    func setupScrollView(){
        scrollView = CustomScrollView(frame: CGRect(x:0, y: 0, width: view.frame.width, height: view.frame.height))
        
        
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        //also another approach: pin image view to scrollview, make sure it has an intrinsic size
        self.scrollView!.contentSize = CGSize(width:self.scrollView!.frame.size.width * 2,height: self.scrollView!.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.indicatorStyle = .white
        scrollView.backgroundColor = UIColor.gray
        
        setupCanvasView()
        setupResetButton()
        
        scrollView.touchDelegate = canvasView
        scrollView.addSubview(canvasView)
        
        view.addSubview(scrollView)
        view.addSubview(resetButton)
        //we must add constraints after we have added subviews to parent view, otherwise you're adding constraints in subviews that are in different view hierarchy from the parent view you reference.
        resetButton.snp.makeConstraints{ make -> Void in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        scrollView.contentOffset = CGPoint(x: view.frame.width / 2.0, y: 0)
        
    }
    
    func setupCanvasView(){
        canvasView = CanvasView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height))
        
    }
    
    
    func setupResetButton(){
        let origin = CGPoint(x: self.view.frame.width / 2.0, y: 0)
        let size = CGSize(width: 75, height: 50)
        resetButton = UIButton(frame: CGRect(origin: origin, size: size))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.red, for: .normal)
        resetButton.addTarget(self,action: #selector(resetTapped), for: UIControl.Event.touchUpInside)
        
//        let safeAreaGuide = view.safeAreaLayoutGuide
//
//        resetButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor).isActive = true
//        resetButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor).isActive = true

        
    }
    
    @objc func resetTapped(){
        canvasView.reset()
    }
    
//level by level growth. Also slow by the end.
    
    
//    func drawLevel(){
//        print(currentDepth)
//        if currentDepth < 0 {
//            context?.setFillColor(UIColor.black.cgColor)
//            context?.fill(CGRect(x: 0, y: 0, width: self.canvasView.bounds.width * UIScreen.main.scale , height: self.canvasView.bounds.height * UIScreen.main.scale))
//            self.canvasView.image = nil
//            setupFirstLevel()
//            return
//
//        }
//
//        var nextLevel = [TreeNode]()
//        if let currentTreeLevel = currentLevel{
//            for node in currentTreeLevel{
//                context.setLineWidth(CGFloat(Double(currentDepth) / 10.0))
//                context.setStrokeColor(UIColor(hue: CGFloat(Double(currentDepth) / Double(treeDepth)), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
//                drawLine(fromPoint: node.origin, toPoint: node.endPoint)
//                let leftChild = TreeNode(origin: node.endPoint, angle: node.angle - self.leftAngle, length: Double(currentDepth))
//                let rightChild = TreeNode(origin: node.endPoint, angle: node.angle + self.rightAngle, length: Double(currentDepth))
//                nextLevel.append(leftChild)
//                nextLevel.append(rightChild)
//            }
//            currentLevel = nextLevel
//            currentDepth -= 1
//        }
//
//        if let levelImage = context.makeImage(){
//            self.canvasView.image = UIImage(cgImage: levelImage)
//        }
//    }
    
    
    
    
    
    
    
    
//complete BFS growth. Very slow at the end.
    
//    func drawTreeGrowth(){
//
//        let root = TreeNode(origin: CGPoint(x:self.canvasView.frame.size.width/2,y:0), angle: 90, length: Double(self.treeDepth))
//        var currentLevel = [root]
//        var currentDepth = treeDepth
//
//        while(currentDepth > 0){
//            //auto release pool will request 'release' of objects in its scope, which decrements its retain count by 1 to ensure this finalImage doesn't hog memory when it should be released.
//            //autoreleasepool {
//                //DispatchQueue.main.async {
////            if let finalImage = self.context.makeImage() {
////                self.canvasView.image = UIImage(cgImage: finalImage)
////            }
//
//            var nextLevel = [TreeNode]()
//
//            context.setLineWidth(CGFloat(Double(currentDepth) / 10.0))
//            context.setStrokeColor(UIColor(hue: CGFloat(Double(currentDepth) / Double(treeDepth)), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
//            for node in currentLevel{
//                drawLine(fromPoint: node.origin, toPoint: node.endPoint)
//                let leftChild = TreeNode(origin: node.endPoint, angle: node.angle - self.leftAngle, length: Double(currentDepth))
//                let rightChild = TreeNode(origin: node.endPoint, angle: node.angle + self.rightAngle, length: Double(currentDepth))
//                nextLevel.append(leftChild)
//                nextLevel.append(rightChild)
//            }
//
//
//            currentLevel = nextLevel
//            currentDepth -= 1
//        }
//
//        if let finalImage = self.context.makeImage() {
//            self.canvasView.image = UIImage(cgImage: finalImage)
//        } else {
//            print("failed!")
//        }
//    }
    

    
    
}


extension ViewController: UIScrollViewDelegate {
    //there's another way to define image view's relationship to scrollview! 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canvasView.userIsTouchingScreen = false 
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    //do this for other delegate functions
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(#function)
//    }
}
