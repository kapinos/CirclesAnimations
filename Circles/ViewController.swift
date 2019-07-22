//
//  ViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isAnimate = true
    var flowerView: AnimatableFlowerCubeView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        flowerView = AnimatableFlowerCubeView(frame: CGRect(origin: .zero, size: CGSize(width: 3*70, height: 3*70)))
        self.view.addSubview(flowerView!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.flowerView?.center = self.view.center
    }

    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: self.view)
        if (flowerView?.frame.contains(touchPoint))! {
            flowerView?.animate(isAnimate)
            isAnimate = !isAnimate
        }
    }
}


class AnimatableFlowerCubeView: UIView {
    private var cubeViews: [CubeView] = []
    private let amount = 9
    private let size: CGFloat = 70
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<amount {
            cubeViews.append(CubeView(size: 70, with: AnimationType.flower))
        }
        let startPoint = CGPoint(x: size/2, y: size/2)
        
        var j = 0
        for i in 0...2 {
            for y in 0...2 {
                let point = CGPoint(x: startPoint.x + size * CGFloat(y), y: startPoint.y + size * CGFloat(i))
                cubeViews[j].appendTo(superview: self, on: point)
                j += 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(_ isAnimate: Bool = true) {
        _ = self.cubeViews.map{ isAnimate ? $0.animate() : $0.stopAnimation() }
    }
}
