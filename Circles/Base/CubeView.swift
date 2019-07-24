//
//  CubeView.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/22/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

enum AnimationType {
    case fan, flower, ugly
}

struct CubeView {
    private let size: CGFloat
    private var views: [UIView] = []
    private var transformedPaths: [CGPath] = []
    private let amountViews = 4
    private let animationType: AnimationType
    
    init(size: CGFloat, with animationType: AnimationType) {
        self.size = size/2
        self.animationType = animationType
        
        for _ in 0..<amountViews {
            self.views.append(UIView())
        }
    }
}


// MARK: - Private
private extension CubeView {
    func getRotationAnimation(with duration: Double) -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value:  Double.pi/2)
        rotation.duration = duration
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return rotation
    }
    
    func getLayers(by name: String) -> [CAShapeLayer] {
        let sublayers = self.views
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }.filter{ $0.name! == name }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        
        return sublayers
    }
    
    mutating func addLayersTo(cubeView: UIView, in quarter: Int) {
        let quarterValue = Quarters(rawValue: quarter) ?? Quarters.first
        
        let coordinates = SublayersCoordinates(quarter: quarterValue, bounds: cubeView.bounds)
        
        transformedPaths.append(getTransformedArcPath(for: coordinates).cgPath)
        
        let arcLayer = CAShapeLayer()
        arcLayer.path = getOriginArcPath(for: coordinates).cgPath
        arcLayer.strokeColor = LayerProperties.strokeColor
        arcLayer.lineWidth = LayerProperties.lineWidth
        arcLayer.name = "arc"
        
        let linePath = UIBezierPath()
        linePath.move(to: coordinates.endPoint)
        linePath.addLine(to: coordinates.startPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = self.animationType == .fan ? UIColor.clear.cgColor : LayerProperties.strokeColor
        lineLayer.lineWidth = LayerProperties.lineWidth
        lineLayer.name = "line"
        
        cubeView.layer.addSublayer(arcLayer)
        cubeView.layer.addSublayer(lineLayer)
    }
    
    func getOriginArcPath(for coordinates: SublayersCoordinates) -> UIBezierPath {
        let originStartAngle = self.animationType == .fan
            ? coordinates.originArc.endAngle
            : coordinates.originArc.startAngle
        
        let originEndAngle = self.animationType == .fan
            ? coordinates.originArc.startAngle
            : coordinates.originArc.endAngle
        
        let arcPath = UIBezierPath(arcCenter:   coordinates.originArc.center,
                                   radius:      size,
                                   startAngle:  originStartAngle,
                                   endAngle:    originEndAngle,
                                   clockwise:   true)
        return arcPath
    }
    
    func getTransformedArcPath(for coordinates: SublayersCoordinates) -> UIBezierPath {
        let transformedStartAngle = self.animationType == .ugly
            ? coordinates.transformedArc.endAngle : coordinates.transformedArc.startAngle
        let transformedEndAngle = self.animationType == .ugly
            ? coordinates.transformedArc.startAngle : coordinates.transformedArc.endAngle
        
        let transformedPath = UIBezierPath(arcCenter:   coordinates.transformedArc.center,
                                           radius:      size,
                                           startAngle:  transformedStartAngle,
                                           endAngle:    transformedEndAngle,
                                           clockwise:   true)
        return transformedPath
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
}


// MARK: - Public
extension CubeView {
    mutating func appendTo(superview: UIView, on point: CGPoint) {
        let points = [
            CGPoint(x: point.x,        y: point.y),
            CGPoint(x: point.x - size, y: point.y),
            CGPoint(x: point.x - size, y: point.y - size),
            CGPoint(x: point.x,        y: point.y - size),
        ]
        
        for i in 0..<amountViews {
            if let view = views[safe: i], let point = points[safe: i] {
                view.frame = CGRect(origin: point, size: CGSize(width: size, height: size))
                addLayersTo(cubeView: view, in: i+1)
                superview.addSubview(view)
            }
        }
    }
    
    func animate(duration: Double = 1.5) {
        switch self.animationType {
        case .fan:
            self.circleAnimation(with: duration)
        case .flower, .ugly:
            self.basicAnimation(with: duration)
        }
    }
}


// MARK: - Animation Types
private extension CubeView {
    func basicAnimation(with duration: Double) {
        let rotation = getRotationAnimation(with: duration)
        self.views.forEach { view in
            view.layer.add(rotation, forKey: "rotation")
        }
        
        //_ = self.views.map{ $0.layer.add(rotation, forKey: "rotation") }
        
        let lineSublayers = getLayers(by: "line")
        for i in 0..<amountViews {
            if let lineSublayer = lineSublayers[safe: i], let path = transformedPaths[safe: i] {
                let pathAnimation = CABasicAnimation(keyPath: "path")
                pathAnimation.toValue = path
                pathAnimation.duration = duration
                pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                pathAnimation.autoreverses = true
                pathAnimation.repeatCount = .greatestFiniteMagnitude
                
                lineSublayer.add(pathAnimation, forKey: "pathAnimation")
            }
        }
    }
    
    func circleAnimation(with duration: Double) {
        let rotation = getRotationAnimation(with: duration)
        let arcSublayers = getLayers(by: "arc")
        arcSublayers.forEach { shapeLayer in
            shapeLayer.add(rotation, forKey: "rotation")
        }
//        _ = arcSublayers.map{ $0.add(rotation, forKey: "rotation") }
        
        let lineSublayers = getLayers(by: "line")
        
        for i in 0..<self.amountViews {
            if let lineSublayer = lineSublayers[safe: i], let path = transformedPaths[safe: i] {
                let pathAnimation = CABasicAnimation(keyPath: "path")
                pathAnimation.toValue = path
                pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                pathAnimation.autoreverses = true
                
                var animations = [CABasicAnimation]()
                animations.append(rotation)
                animations.append(pathAnimation)
                
                let groupAnimations = CAAnimationGroup()
                groupAnimations.duration = duration
                groupAnimations.autoreverses = true
                groupAnimations.animations = animations
                groupAnimations.repeatCount = .greatestFiniteMagnitude
                lineSublayer.add(groupAnimations, forKey: "groupAnimation")
            }
        }
    }
}
