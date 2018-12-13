//
//  ViewController.swift
//  TreeFractal2Demo
//
//  Created by Jerry Wang on 11/15/18.
//  Copyright © 2018 Jerry Wang. All rights reserved.
//

import UIKit
import SnapKit
import SpriteKit

class ViewController: UIViewController {

    var scrollView: CustomScrollView!
    var canvasView: CanvasView!
    var spriteKitView: SKView!
    
    var resetButton: UIButton!
    var drawLevelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    func setupScrollView(){
        
        
        scrollView = CustomScrollView(frame: CGRect(x:0, y: 0, width: view.frame.width, height: view.frame.height))
        
        
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clear
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.indicatorStyle = .white
        
        
        
        setupCanvasView()
        setupSKScene()
        setupResetButton()
        setupDrawLevelButton()
        
        scrollView.touchDelegate = canvasView
        
//        canvasView.addSubview(spriteKitView)
//        canvasView.sendSubviewToBack(spriteKitView)
        
        //scrollView.addSubview(canvasView)
        scrollView.addSubview(spriteKitView)
        spriteKitView.addSubview(canvasView)
        
        view.addSubview(scrollView)
        view.addSubview(resetButton)
        view.addSubview(drawLevelButton)
        
        //Swift will automatically add constraints to your views, unless you tell it that you are adding them yourself. If you don't set translatesAutoresizing to false, your constraints will conflict with automatically generated constraints.

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        spriteKitView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        drawLevelButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        //we must add constraints after we have added subviews to parent view, otherwise you're adding constraints in subviews that are in different view hierarchy from the parent view you reference.
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        
        //center the scrollview's content to be in the middle of the screen
        scrollView.contentOffset = CGPoint(x: view.frame.width / 2.0, y: 0)
        
        
        NSLayoutConstraint.activate(
        [canvasView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        canvasView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        canvasView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        canvasView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        canvasView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        canvasView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2.0)
        ])
        
        
        NSLayoutConstraint.activate(
            [spriteKitView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
             spriteKitView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
             
             spriteKitView.topAnchor.constraint(equalTo: canvasView.topAnchor),
             spriteKitView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            

        
        resetButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        
        drawLevelButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        drawLevelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        
        
    }
    
    func setupSKScene(){
        spriteKitView = SKView(frame: CGRect(x: 0, y: 0, width: canvasView.frame.width, height: canvasView.frame.height))
        
        
        
//        if let spView = spriteKitView as SKView? {
//            // Load the SKScene from 'GameScene.sks'
        if let scene = SpriteKitScene(fileNamed: "SpriteKitScene") {
                // Set the scale mode to scale to fit the window
                //scene.scaleMode = .aspectFill
                
                // Present the scene
            spriteKitView.presentScene(scene)
            spriteKitView.ignoresSiblingOrder = true
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true

        }
        spriteKitView.scene?.backgroundColor = UIColor.clear
        //}
        
    }
    
    func setupCanvasView(){
        canvasView = CanvasView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height))
        canvasView.backgroundColor = UIColor.clear
    }
    
    
    func setupResetButton(){
        let origin = CGPoint(x: self.view.frame.width / 2.0, y: 10)
        let size = CGSize(width: 75, height: 50)
        resetButton = UIButton(frame: CGRect(origin: origin, size: size))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.red, for: .normal)
        resetButton.addTarget(self,action: #selector(resetTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func resetTapped(){
        canvasView.reset()
    }
    
    func setupDrawLevelButton(){
        let origin = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height - 50)
        let size = CGSize(width: 75, height: 50)
        drawLevelButton = UIButton(frame: CGRect(origin: origin, size: size))
        drawLevelButton.setTitle("Draw Level", for: .normal)
        drawLevelButton.setTitleColor(UIColor.red, for: .normal)
        drawLevelButton.addTarget(self, action: #selector(drawLevelTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func drawLevelTapped(){
        canvasView.drawLevel()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


extension ViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return spriteKitView
        //return canvasView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canvasView.userIsTouchingScreen = false 
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

}
