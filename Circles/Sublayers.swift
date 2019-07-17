//
//  Sublayers.swift
//  Circles
//
//  Created by Anastasia Kapinos on 7/16/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

struct LayerProperties {
    static let lineWidth: CGFloat = 1.2
    static let strokeColor: CGColor = UIColor.white.cgColor
}

struct SublayersCoordinates {
    var startPoint: CGPoint
    var endPoint:   CGPoint
    var startAngle: CGFloat
    var endAngle:   CGFloat
    var arcCenter:  CGPoint
    
    init(quarter: Int, bounds: CGRect) {
        switch quarter {
        case 1:
            startPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
            endPoint   = CGPoint(x: bounds.minX, y: bounds.maxY)
            startAngle = 0
            endAngle   = CGFloat.pi / 2
            arcCenter  = CGPoint.zero
            
        case 2:
            startPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
            endPoint   = CGPoint(x: bounds.minX, y: bounds.minY)
            startAngle = CGFloat.pi / 2
            endAngle   = CGFloat.pi
            arcCenter  = CGPoint(x: bounds.maxX, y: bounds.minY)
            
        case 3:
            startPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
            endPoint   = CGPoint(x: bounds.maxX, y: bounds.minY)
            startAngle = CGFloat.pi
            endAngle   = 3 * CGFloat.pi / 2
            arcCenter  = CGPoint(x: bounds.maxX, y: bounds.maxY)
            
        case 4:
            startPoint = CGPoint(x: bounds.minX, y: bounds.minY)
            endPoint   = CGPoint(x: bounds.maxX, y: bounds.maxY)
            startAngle = 3 * CGFloat.pi / 2
            endAngle   = 2 * CGFloat.pi
            arcCenter  = CGPoint(x: bounds.minX, y: bounds.maxY)
            
        default:
            startPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
            endPoint   = CGPoint(x: bounds.minX, y: bounds.maxY)
            startAngle = 0
            endAngle   = CGFloat.pi / 2
            arcCenter  = CGPoint.zero
        }
    }
}
