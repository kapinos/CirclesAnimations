//
//  ViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let circleView = UIView()
    
    var cubeViews: [UIView] = []
    let size: CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        for _ in 0...3 {
            self.cubeViews.append(UIView())
        }
        
        //addCubeView(with: 50, on: self.view.center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let rotation = CABasicAnimation(keyPath: "transform.rotation")
//        rotation.toValue = NSNumber(value:  Double.pi/2)
//        rotation.duration = 2
//        rotation.repeatCount = 1
//        rotation.autoreverses = true
////        rotation.repeatCount = .infinity
////        rotation.isCumulative = true
//        self.circleView.layer.add(rotation, forKey: "lineRotation")
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
        
        //animateCubeView()
        
        for cube in cubeViews {
            UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear, .curveEaseIn], animations: {
                let animation = CATransform3DMakeRotation(self.degreesToRadians(90), 0, 0, -10)
                cube.layer.transform = animation
                
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(0.5)
//
//                cube.layer.backgroundColor = UIColor.red.cgColor
//
//                CATransaction.commit()
                
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
}

private extension ViewController {
    func addLayersTo(cubeView: UIView, in quarter: Int) {
        let coordinates = SublayersCoordinates(quarter: quarter, bounds: cubeView.bounds)
        
        let quarterPath = UIBezierPath(arcCenter:   coordinates.arcCenter,
                                       radius:      size,
                                       startAngle:  coordinates.startAngle,
                                       endAngle:    coordinates.endAngle,
                                       clockwise:   true)
        
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
        
        self.view.addSubview(cubeView)
    }
}





//------------------------------------------------
// MARK: - CubeView
private extension ViewController {
    func animateCubeView() {
        UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear, .curveEaseIn], animations: {
            let animation = CATransform3DMakeRotation(self.degreesToRadians(90), 0, 0, -10)
            self.circleView.layer.transform = animation
            for layer in self.circleView.layer.sublayers! {
                // print(layer.name!)
//                layer.transform = animation
            }
        }, completion: nil)
    }

    
    func addCubeView(with size: CGFloat, on origin: CGPoint) {
        circleView.frame = CGRect(origin: origin,
                                  size:   CGSize(width: size, height: size))

        let quarterPath = UIBezierPath(arcCenter:   CGPoint.zero,
                                       radius:      size,
                                       startAngle:  0,
                                       endAngle:    CGFloat.pi / 2,
                                       clockwise:   true)

        let quarterLayer = CAShapeLayer()
        quarterLayer.path = quarterPath.cgPath
        quarterLayer.strokeColor = UIColor.white.cgColor
        quarterLayer.lineWidth = 1.8
        quarterLayer.name = "quarter"

        let startPoint = CGPoint(x: circleView.bounds.minX, y: circleView.bounds.maxY)
        let endPoint   = CGPoint(x: circleView.bounds.maxX, y: circleView.bounds.minY)

        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 1.8
        lineLayer.name = "line"
        
        circleView.layer.addSublayer(quarterLayer)
        circleView.layer.addSublayer(lineLayer)
        circleView.backgroundColor = .lightGray
        
        self.view.addSubview(circleView)
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
}
