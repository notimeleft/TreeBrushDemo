//
//  ScrollView.swift
//  TreeFractal2Demo
//
//  Created by Jerry Wang on 11/17/18.
//  Copyright © 2018 Jerry Wang. All rights reserved.
//

import UIKit

protocol ScrollViewTouchDelegate {
    func UserTouchedScrollView()
    func UserStoppedTouchingScrollView()
}

class CustomScrollView : UIScrollView {
    
    var touchDelegate: ScrollViewTouchDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.UserTouchedScrollView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.UserStoppedTouchingScrollView()
    }
}
