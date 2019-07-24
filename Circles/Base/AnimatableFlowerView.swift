//
//  AnimatableFlowerView.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/23/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class AnimatableFlowerCubeView: UIView {
    private var cubeViews: [CubeView] = []
    private var size: CGFloat = 50
    private var amount = 4
    private(set) var isAnimate = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width != frame.size.height {
            assertionFailure("View's frame has to be square")
            return
            // preconditionFailure("View has to be square")
        }
        
        fillWithSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Private
private extension AnimatableFlowerCubeView {
    func fillWithSubviews() {
        self.size = self.bounds.size.width / CGFloat(amount)
        
        for _ in 0..<amount*amount {
            cubeViews.append(CubeView(size: self.size, with: .flower))
        }
        
        let startPoint = CGPoint(x: size/2, y: size/2)
        
        var j = 0
        for i in 0..<amount {
            for y in 0..<amount {
                let point = CGPoint(x: startPoint.x + size * CGFloat(y), y: startPoint.y + size * CGFloat(i))
                cubeViews[j].appendTo(superview: self, on: point)
                j += 1
            }
        }
    }
    
    func stopSublayerAnimations(layer: CALayer) {
        layer.sublayers?.forEach({ layer in
            stopSublayerAnimations(layer: layer)
            layer.removeAllAnimations()
        })
    }
}


// MARK: - Public
extension AnimatableFlowerCubeView {
    func animate() {
        guard !isAnimate else { return }
        isAnimate = true
        self.cubeViews.forEach { view in
            view.animate()
        }
    }
    
    func stopAnimation() {
        guard isAnimate else { return }
        isAnimate = false
        
        stopSublayerAnimations(layer: self.layer)
    }
}

