//
//  MainViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    private var fanView: CubeView?
    private var cubicleView: AnimatableCubicleView?
    private var flowerView: CubeView?
    
    private let viewSize: CGFloat = 100

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        addAnimationSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let orientation = UIDevice.current.orientation
        
        let center = self.view.center
        let shift = 40 + viewSize*1.5
        
        if (orientation == .landscapeLeft || orientation == .landscapeRight) {
            self.fanView?.center    = CGPoint(x: shift, y: center.y)
            self.cubicleView?.center = center
            self.flowerView?.center   = CGPoint(x: self.view.bounds.width - shift, y: center.y)
        }
        else if (orientation == .portrait || orientation == .portraitUpsideDown) {
            self.fanView?.center    = CGPoint(x: center.x, y: shift)
            self.cubicleView?.center = center
            self.flowerView?.center   = CGPoint(x: center.x, y: self.view.bounds.height - shift)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            UIView.setAnimationsEnabled(true)
        })
        
        UIView.setAnimationsEnabled(false)
        super.viewWillTransition(to: size, with: coordinator)
    }
}


// MARK: - Private
private extension MainViewController {
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: self.view)
        
        fanView?.checkForTap(by: touchPoint)
        flowerView?.checkForTap(by: touchPoint)
        cubicleView?.checkForTap(by: touchPoint)
    }
    
    func addAnimationSubviews() {
        fanView = CubeView(frame: CGRect(origin: .zero, size: CGSize(width: viewSize, height: viewSize)))
        fanView?.animationType = .fan
        self.view.addSubview(fanView!)
        
        cubicleView = AnimatableCubicleView(frame: CGRect(origin: .zero, size: CGSize(width: viewSize*2, height: viewSize*2)))
        self.view.addSubview(cubicleView!)
        
        flowerView = CubeView(frame: CGRect(origin: .zero, size: CGSize(width: viewSize, height: viewSize)))
        flowerView?.animationType = .flower
        self.view.addSubview(flowerView!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
}
