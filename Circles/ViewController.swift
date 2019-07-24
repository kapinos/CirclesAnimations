//
//  ViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var flowerView: AnimatableFlowerCubeView?
    var fanView: CubeView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        flowerView = AnimatableFlowerCubeView(frame: CGRect(origin: .zero, size: CGSize(width: 170, height: 170)))
        self.view.addSubview(flowerView!)
        
        fanView = CubeView(size: 100, with: .fan)
        fanView?.appendTo(superview: self.view, on: self.view.center)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // TODO: - implement set for positions
        let center = self.view.center
        
        self.flowerView?.center = CGPoint(x: center.x, y: 40+170/2)
//        self.fanView?.cente
    }

    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: self.view)
        
        if (flowerView?.frame.contains(touchPoint))! {
            if flowerView?.isAnimate == false {
                flowerView?.animate()
            } else {
                flowerView?.stopAnimation()
            }
        }
    }
}
