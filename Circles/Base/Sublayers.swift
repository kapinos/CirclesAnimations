//
//  Sublayers.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/16/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

struct LayerProperties {
    static let lineWidth:   CGFloat = 1.2
    static let strokeColor: CGColor = UIColor.white.cgColor
}

enum Quarters: Int {
    case first = 1, second, third, fourth
}

struct Arc {
    let startAngle: CGFloat
    let endAngle:   CGFloat
    let center:     CGPoint
}

struct SublayersCoordinates {
    var startPoint: CGPoint
    var endPoint:   CGPoint
    
    var originArc:      Arc
    var transformedArc: Arc
    
    init(quarter: Quarters, bounds: CGRect) {
        switch quarter {
        case .first:
            startPoint     = CGPoint(x: bounds.maxX, y: bounds.minY)
            endPoint       = CGPoint(x: bounds.minX, y: bounds.maxY)
            originArc      = Arc(startAngle: 0, endAngle: CGFloat.pi/2, center: CGPoint(x: bounds.minX, y: bounds.minY))
            transformedArc = Arc(startAngle: CGFloat.pi, endAngle: 3*CGFloat.pi/2, center: CGPoint(x: bounds.maxX, y: bounds.maxY))
            
        case .second:
            startPoint     = CGPoint(x: bounds.maxX, y: bounds.maxY)
            endPoint       = CGPoint(x: bounds.minX, y: bounds.minY)
            originArc      = Arc(startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, center: CGPoint(x: bounds.maxX, y: bounds.minY))
            transformedArc = Arc(startAngle: 3*CGFloat.pi/2, endAngle: 2*CGFloat.pi, center: CGPoint(x: bounds.minX, y: bounds.maxY))
            
        case .third:
            startPoint     = CGPoint(x: bounds.minX, y: bounds.maxY)
            endPoint       = CGPoint(x: bounds.maxX, y: bounds.minY)
            originArc      = Arc(startAngle: CGFloat.pi, endAngle: 3*CGFloat.pi/2, center: CGPoint(x: bounds.maxX, y: bounds.maxY))
            transformedArc = Arc(startAngle: 0, endAngle: CGFloat.pi/2, center: CGPoint(x: bounds.minX, y: bounds.minY))
            
        case .fourth:
            startPoint = CGPoint(x: bounds.minX, y: bounds.minY)
            endPoint   = CGPoint(x: bounds.maxX, y: bounds.maxY)
            originArc      = Arc(startAngle: 3*CGFloat.pi/2, endAngle: 2*CGFloat.pi, center: CGPoint(x: bounds.minX, y: bounds.maxY))
            transformedArc = Arc(startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, center: CGPoint(x: bounds.maxX, y: bounds.minY))
        }
    }
}
