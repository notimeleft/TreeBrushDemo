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
    var drawLevelButton: UIButton!
    
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
        setupDrawLevelButton()
        
        scrollView.touchDelegate = canvasView
        scrollView.addSubview(canvasView)
        
        view.addSubview(scrollView)
        view.addSubview(resetButton)
        view.addSubview(drawLevelButton)
        
        //we must add constraints after we have added subviews to parent view, otherwise you're adding constraints in subviews that are in different view hierarchy from the parent view you reference.
        resetButton.snp.makeConstraints{ make -> Void in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
        
        drawLevelButton.snp.makeConstraints{ make -> Void in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
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
    
}


extension ViewController: UIScrollViewDelegate {

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

}
