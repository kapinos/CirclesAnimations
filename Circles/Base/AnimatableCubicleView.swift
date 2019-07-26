//
//  AnimatableCubicleView.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/23/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class AnimatableCubicleView: UIView {
    private var cubeViews: [CubeView] = []
    private var size: CGFloat = 50
    private var amount = 4
    
    private(set) var isAnimate = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width != frame.size.height {
            assertionFailure("View's frame has to be square")
            return
        }
        
        fillWithSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Private
private extension AnimatableCubicleView {
    func fillWithSubviews() {
        self.size = self.bounds.size.width / CGFloat(amount)
        
        for _ in 0..<amount*amount {
            let cubeView = CubeView(frame: CGRect(origin: .zero, size: CGSize(width: self.size, height: self.size)))
            cubeView.animationType = .cubicle
            cubeViews.append(cubeView)
        }
        
        var j = 0
        for i in 0..<amount {
            for y in 0..<amount {
                cubeViews[j].frame.origin = CGPoint(x: size * CGFloat(y), y: size * CGFloat(i))
                self.addSubview(cubeViews[j])
                j += 1
            }
        }
    }
    
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
        
        self.cubeViews.forEach{ view in
            view.stopAnimation()
        }
    }
}


// MARK: - Public
extension AnimatableCubicleView {
    func checkForTap(by point: CGPoint) {
        guard self.frame.contains(point) else { return }
        
//        if self.frame.contains(point) {
            if !isAnimate {
                animate()
            } else {
                stopAnimation()
            }
//        }
    }
}
