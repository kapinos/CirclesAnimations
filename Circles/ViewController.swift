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
        
        //animateCALayers()
        //animateCubeViews()
        
        let lineSublayers = self.cubeViews
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }
            .filter{ $0.name! == "line" }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        
        for i in 0..<self.cubeViews.count {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = transformedPaths[i]
            pathAnimation.duration = 1.5
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathAnimation.autoreverses = true
            pathAnimation.repeatCount = .greatestFiniteMagnitude

            lineSublayers[i].add(pathAnimation, forKey: "pathAnimation")
        }
    }
}

private extension ViewController {
    func animateCALayers() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value:  Double.pi/2)
        rotation.duration = 1.5
        rotation.repeatCount = 1
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        _ = self.cubeViews.map{ $0.layer.add(rotation, forKey: "rotation") }
        
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.toValue = UIColor.cyan.cgColor
        strokeColorAnimation.duration = 3
        strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        // strokeColorAnimation.autoreverses = true
        strokeColorAnimation.repeatCount = .greatestFiniteMagnitude
        
        let sublayers = self.cubeViews
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }
            .filter{ $0.name! == "line" }
        _ = sublayers.map{ $0.add(strokeColorAnimation, forKey: "strokeColorAnimation") }
    }
    
    func animateCubeViews() {
        for cube in cubeViews {
            UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear, .curveEaseIn], animations: {
                let animation = CATransform3DMakeRotation(self.degreesToRadians(90), 0, 0, -10)
                cube.layer.transform = animation
                
                // CATransaction.begin()
                // CATransaction.setAnimationDuration(0.5)
                // cube.layer.backgroundColor = UIColor.red.cgColor
                //
                // CATransaction.commit()
                
                for case let layer in cube.layer.sublayers! {
                    if let shapeLayer = layer as? CAShapeLayer  {
                        if shapeLayer.name! == "line" {
                            
                            //shapeLayer.transform = animation
                            //shapeLayer.strokeColor = UIColor.red.cgColor
                        }
                    }
                }
            }, completion: nil)
        }
    }
    
    func addLayersTo(cubeView: UIView, in quarter: Int) {
        let coordinates = SublayersCoordinates(quarter: quarter, bounds: cubeView.bounds)
        
        let quarterPath = UIBezierPath(arcCenter:   coordinates.arcCenter,
                                       radius:      size,
                                       startAngle:  coordinates.startAngle,
                                       endAngle:    coordinates.endAngle,
                                       clockwise:   true)
        
        let transformedPath = UIBezierPath(arcCenter:   coordinates.transfromedCenter,
                                           radius:      size,
                                           startAngle:  coordinates.transformedStartAngle,
                                           endAngle:    coordinates.transformedEndAngle,
                                           clockwise:   false)
        transformedPaths.append(transformedPath.cgPath)
        
        let quarterLayer = CAShapeLayer()
        quarterLayer.path = quarterPath.cgPath
        quarterLayer.strokeColor = LayerProperties.strokeColor
        quarterLayer.lineWidth = LayerProperties.lineWidth
        quarterLayer.name = "quarter"
        
        let linePath = UIBezierPath()
        linePath.move(to: coordinates.startPoint)
        linePath.addLine(to: coordinates.endPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = LayerProperties.strokeColor
        lineLayer.lineWidth = LayerProperties.lineWidth
        lineLayer.name = "line"
        
        cubeView.layer.addSublayer(quarterLayer)
        cubeView.layer.addSublayer(lineLayer)
        //cubeView.layer.backgroundColor = UIColor.red.cgColor
        
        self.view.addSubview(cubeView)
    }
}
