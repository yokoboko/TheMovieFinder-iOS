//
//  GradientView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView, CAAnimationDelegate {
    
    @IBInspectable public var startColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    @IBInspectable public var endColor: UIColor = .black {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    open override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer! {
        get {
            return (layer as! CAGradientLayer)
        }
    }
}
