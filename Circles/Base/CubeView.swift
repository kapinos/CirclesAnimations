//
//  CubeView.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/22/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

enum AnimationType {
    case fan, cubicle, flower
}

class CubeView: UIView {
    var animationType: AnimationType = .fan {
        didSet {
            self.fillView()
        }
    }
    
    private(set) var isAnimate = false    
    private var size: CGFloat = 50
    private var views: [UIView] = []
    private var transformedPaths: [CGPath] = []
    private let amountViews = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width != frame.size.height {
            assertionFailure("View's frame has to be square")
            return
        }
        
        self.size = frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Private
private extension CubeView {
    func fillView() {
        let points = [
            CGPoint(x: center.x,        y: center.y),
            CGPoint(x: center.x - size, y: center.y),
            CGPoint(x: center.x - size, y: center.y - size),
            CGPoint(x: center.x,        y: center.y - size),
        ]
        
        for i in 0..<amountViews {
            if let point = points[safe: i] {
                let view = UIView(frame: CGRect(origin: point, size: CGSize(width: size, height: size)))
                addLayersTo(cubeView: view, in: i+1)
                self.views.append(view)
                self.addSubview(view)
            }
        }
    }
    
    func getLayers(by name: String) -> [CAShapeLayer] {
        let sublayers = self.views
            .map{ $0.layer.sublayers }
            .compactMap{ $0 }.flatMap{ $0 }.filter{ $0.name! == name }.map{ $0 as? CAShapeLayer }.compactMap{ $0 }
        
        return sublayers
    }
    
    func addLayersTo(cubeView: UIView, in quarter: Int) {
        let quarterValue = Quarters(rawValue: quarter) ?? Quarters.first
        
        let coordinates = SublayersCoordinates(quarter: quarterValue, bounds: cubeView.bounds)
        
        transformedPaths.append(getTransformedArcPath(for: coordinates).cgPath)
        
        let arcLayer = CAShapeLayer()
        arcLayer.path = getOriginArcPath(for: coordinates).cgPath
        arcLayer.strokeColor = LayerProperties.strokeColor
        arcLayer.lineWidth = LayerProperties.lineWidth
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.name = "arc"
        
        let linePath = UIBezierPath()
        linePath.move(to: coordinates.endPoint)
        linePath.addLine(to: coordinates.startPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = self.animationType == .fan ? UIColor.clear.cgColor : LayerProperties.strokeColor
        lineLayer.fillColor = UIColor.clear.cgColor
        
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
        let transformedStartAngle = self.animationType == .flower
    
            ? coordinates.transformedArc.endAngle
            : coordinates.transformedArc.startAngle
        let transformedEndAngle = self.animationType == .flower
            ? coordinates.transformedArc.startAngle
            : coordinates.transformedArc.endAngle
        
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
    
    func stopSublayerAnimations(layer: CALayer) {
        layer.sublayers?.forEach({ layer in
            stopSublayerAnimations(layer: layer)
            layer.removeAllAnimations()
        })
    }
}


// MARK: - Public
extension CubeView {
    func checkForTap(by point: CGPoint) {
        guard self.frame.contains(point) else { return }
        
        if isAnimate == false {
            animate()
        } else {
            stopAnimation()
        }
    }
    
    func animate(duration: Double = 2.5) {
        guard !isAnimate else { return }
        isAnimate = true
        
        switch animationType {
        case .fan:
            fanAnimation(with: duration)
        case .cubicle, .flower:
            basicAnimation(with: duration)
        }
    }
    
    func stopAnimation() {
        guard isAnimate else { return }
        isAnimate = false
        
        stopSublayerAnimations(layer: self.layer)
    }
}


// MARK: - Animation Types
private extension CubeView {
    func basicAnimation(with duration: Double) {
        let rotation = getRotationAnimation(with: duration)
        self.views.forEach { view in
            view.layer.add(rotation, forKey: "rotation")
        }
        
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
    
    func fanAnimation(with duration: Double) {
        let rotation = getRotationAnimation(with: duration)
        let arcSublayers = getLayers(by: "arc")
        arcSublayers.forEach { shapeLayer in
            shapeLayer.add(rotation, forKey: "rotation")
        }
        
        let lineSublayers = getLayers(by: "line")
        
        for i in 0..<self.amountViews {
            if let lineSublayer = lineSublayers[safe: i], let path = transformedPaths[safe: i] {
                let pathAnimation = CABasicAnimation(keyPath: "path")
                pathAnimation.toValue = path
                pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                pathAnimation.autoreverses = true
                
                let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
                strokeColorAnimation.toValue = UIColor.white.cgColor
                strokeColorAnimation.duration = duration * 1.5
                strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

                var animations = [CABasicAnimation]()
                animations.append(rotation)
                animations.append(pathAnimation)
                animations.append(strokeColorAnimation)
                
                let groupAnimations = CAAnimationGroup()
                groupAnimations.duration = duration
                groupAnimations.autoreverses = true
                groupAnimations.animations = animations
                groupAnimations.repeatCount = .greatestFiniteMagnitude
                lineSublayer.add(groupAnimations, forKey: "groupAnimation")
            }
        }
    }
    
    func getRotationAnimation(with duration: Double) -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value:  Double.pi/2)
        rotation.duration = duration
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        return rotation
    }
}
