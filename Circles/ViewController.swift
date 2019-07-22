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
        cubeView = CubeView(size: 70, with: AnimationType.flower)
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
