//
//  ViewController.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/15/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cubeView: CubeView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        cubeView = CubeView(size: 70)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.cubeView!.appendTo(superview: self.view, on: self.view.center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cubeView!.animate()
    }
}


struct CubeView {
    private let size: CGFloat
    private var views: [UIView] = []
    private var transformedPaths: [CGPath] = []
    private let amountViews = 4
    
    init(size: CGFloat) {
        self.size = size/2
        
        for _ in 0..<amountViews {
            self.views.append(UIView())
        }
    }
    
    mutating func appendTo(superview: UIView, on point: CGPoint) {
        let points = [
            CGPoint(x: point.x,        y: point.y),
            CGPoint(x: point.x - size, y: point.y),
            CGPoint(x: point.x - size, y: point.y - size),
            CGPoint(x: point.x,        y: point.y - size),
        ]
        
        for i in 0..<amountViews {
            views[i].frame = CGRect(origin: points[i], size: CGSize(width: size, height: size))
            addLayersTo(cubeView: views[i], in: i+1)
            superview.addSubview(views[i])
        }
    }
    
    func animate(duration: Double = 1.5) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value:  Double.pi/2)
        rotation.duration = duration
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        _ = self.views.map{ $0.layer.add(rotation, forKey: "rotation") }
        
        let sublayers = self.views
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }
        
        let lineSublayers = sublayers.filter{ $0.name! == "line" }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        
        for i in 0..<amountViews {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = transformedPaths[i]
            pathAnimation.duration = duration
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            pathAnimation.autoreverses = true
            pathAnimation.repeatCount = .greatestFiniteMagnitude
            
            lineSublayers[i].add(pathAnimation, forKey: "pathAnimation")
        }
    }
    
    private mutating func addLayersTo(cubeView: UIView, in quarter: Int) {
        let quarterValue = Quarters(rawValue: quarter) ?? Quarters.first
        
        let coordinates = SublayersCoordinates(quarter: quarterValue, bounds: cubeView.bounds)
        
        let quarterPath = UIBezierPath(arcCenter:   coordinates.originArc.center,
                                       radius:      size,
                                       startAngle:  coordinates.originArc.startAngle,
                                       endAngle:    coordinates.originArc.endAngle,
                                       clockwise:   true)
        
        let transformedPath = UIBezierPath(arcCenter:   coordinates.transformedArc.center,
                                           radius:      size,
                                           startAngle:  coordinates.transformedArc.endAngle,
                                           endAngle:    coordinates.transformedArc.startAngle,
                                           clockwise:   true)
        transformedPaths.append(transformedPath.cgPath)
        
        let quarterLayer = CAShapeLayer()
        quarterLayer.path = quarterPath.cgPath
        quarterLayer.backgroundColor = UIColor.clear.cgColor
        quarterLayer.strokeColor = LayerProperties.strokeColor
        quarterLayer.lineWidth = LayerProperties.lineWidth
        quarterLayer.name = "arc"
        
        let linePath = UIBezierPath()
        linePath.move(to: coordinates.endPoint)
        linePath.addLine(to: coordinates.startPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.backgroundColor = UIColor.clear.cgColor
        lineLayer.strokeColor = LayerProperties.strokeColor
        lineLayer.lineWidth = LayerProperties.lineWidth
        lineLayer.name = "line"
        
        cubeView.layer.addSublayer(quarterLayer)
        cubeView.layer.addSublayer(lineLayer)
    }
    
    private func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
}
