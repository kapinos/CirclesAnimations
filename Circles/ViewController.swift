//
//  ViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cubeViews: [UIView] = []
    let size: CGFloat = 50
    
    var transformedPaths: [CGPath] = []
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        for _ in 0...3 {
            self.cubeViews.append(UIView())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let center = self.view.center
        let points = [
            CGPoint(x: center.x,        y: center.y),
            CGPoint(x: center.x - size, y: center.y),
            CGPoint(x: center.x - size, y: center.y - size),
            CGPoint(x: center.x,        y: center.y - size),
        ]
        
        // TODO: - how to zip cubes and points?
        for i in 0..<cubeViews.count {
            cubeViews[i].frame = CGRect(origin: points[i], size: CGSize.init(width: size, height: size))
            addLayersTo(cubeView: cubeViews[i], in: i+1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateCALayers()
        //animateCubeViews()
    }
}

private extension ViewController {
    func animateCALayers() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value:  Double.pi/2)
        rotation.duration = 1.5
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        //_ = self.cubeViews.map{ $0.layer.add(rotation, forKey: "rotation") }
        
        
        
        let sublayers = self.cubeViews
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }
        
        let lineSublayers = sublayers.filter{ $0.name! == "line" }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        let quarterSublayers = sublayers.filter{ $0.name! == "quarter" }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        
        _ = quarterSublayers.map{ $0.add(rotation, forKey: "rotation") }
        
        for i in 0..<self.cubeViews.count {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = transformedPaths[i]
            // pathAnimation.duration = 1.5
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathAnimation.autoreverses = true
            //pathAnimation.repeatCount = .greatestFiniteMagnitude
            
            // change stroke color
            let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
            strokeColorAnimation.toValue = UIColor.white.cgColor
            strokeColorAnimation.duration = 1.5
            strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            var animations = [CABasicAnimation]()
            animations.append(rotation)
            animations.append(pathAnimation)
            animations.append(strokeColorAnimation)

            let groupAnimations = CAAnimationGroup()
            groupAnimations.duration = 1.5
            groupAnimations.autoreverses = true
            groupAnimations.animations = animations
            groupAnimations.repeatCount = .greatestFiniteMagnitude
            lineSublayers[i].add(groupAnimations, forKey: "groupAnimation")
            //lineSublayers[i].add(pathAnimation, forKey: "pathAnimation")
        }
    }
    
    func addLayersTo(cubeView: UIView, in quarter: Int) {
        let coordinates = SublayersCoordinates(quarter: quarter, bounds: cubeView.bounds)
        
        let quarterPath = UIBezierPath(arcCenter:   coordinates.arcCenter,
                                       radius:      size,
                                       startAngle:  coordinates.endAngle,
                                       endAngle:    coordinates.startAngle,
                                       clockwise:   true)
        
        let transformedPath = UIBezierPath(arcCenter:   coordinates.transfromedCenter,
                                           radius:      size,
                                           startAngle:  coordinates.transformedStartAngle,
                                           endAngle:    coordinates.transformedEndAngle,
                                           clockwise:   true)
        transformedPaths.append(transformedPath.cgPath)
        
        let quarterLayer = CAShapeLayer()
        quarterLayer.path = quarterPath.cgPath
        quarterLayer.strokeColor = LayerProperties.strokeColor
        quarterLayer.lineWidth = LayerProperties.lineWidth
        quarterLayer.name = "quarter"
        
        let linePath = UIBezierPath()
        linePath.move(to: coordinates.endPoint)
        linePath.addLine(to: coordinates.startPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.clear.cgColor
//        lineLayer.strokeColor = LayerProperties.strokeColor
        lineLayer.lineWidth = LayerProperties.lineWidth
        lineLayer.name = "line"
        
        cubeView.layer.addSublayer(quarterLayer)
        cubeView.layer.addSublayer(lineLayer)
        //cubeView.layer.backgroundColor = UIColor.red.cgColor
        
        self.view.addSubview(cubeView)
    }
}
