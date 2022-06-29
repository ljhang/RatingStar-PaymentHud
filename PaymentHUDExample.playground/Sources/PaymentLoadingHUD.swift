//
//  PaymentLoadingHUD.swift
//  PaymentHUD
//
//  Created by 李建航 on 2020/5/20.
//  Copyright © 2020 肇庆市华盈体育文化发展有限公司. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public class PaymentLoadingHUD: UIView {
    @IBInspectable open dynamic var animationRadius: CGFloat = 60 {
        didSet {
            if self.animationRadius != oldValue {
                self._animationLayer.bounds = CGRect(x: 0, y: 0, width: self.animationRadius, height: self.animationRadius)
            }
        }
    }
    
    @IBInspectable open dynamic var lineWidth: CGFloat = 4.0 {
        didSet {
            if self.lineWidth != oldValue {
                self._animationLayer.lineWidth = self.lineWidth
            }
        }
    }
    
    @IBInspectable open dynamic var strokeColor: UIColor = .init(red: 16/255, green: 142/255, blue: 233/255, alpha: 1.0) {
        didSet {
            if self.strokeColor != oldValue {
                self._animationLayer.strokeColor = self.strokeColor.cgColor
            }
        }
    }
    
    private lazy var _animationLayer: CAShapeLayer = {
        let animationLayer = CAShapeLayer()
        animationLayer.bounds = CGRect(x: 0, y: 0, width: animationRadius, height: animationRadius)
        animationLayer.fillColor = UIColor.clear.cgColor
        animationLayer.strokeColor = strokeColor.cgColor
        animationLayer.lineWidth = lineWidth
        animationLayer.lineCap = .round
        animationLayer.position = self.center
        return animationLayer
    }()
    private lazy var _link: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(displayLinkAction))
        link.add(to: RunLoop.main, forMode: .default)
        link.isPaused = true
        return link
    }()
    private var _startAngle: CGFloat = 0
    private var _endAngle: CGFloat = 0
    private var _progress: CGFloat = 0
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.layer.addSublayer(self._animationLayer)
    }
}

private extension PaymentLoadingHUD {
    @objc func displayLinkAction() {
        _progress += self.speed()
        if _progress >= 1 {
            _progress = 0
        }
        self.updateAnimationLayer()
    }
    
    func speed() -> CGFloat {
        if _endAngle > CGFloat.pi {
            return 0.3/self.animationRadius
        }
        return 2/self.animationRadius
    }
    
    func updateAnimationLayer() {
        _startAngle = -.pi / 2
        _endAngle = (-.pi / 2) + (_progress * .pi * 2)
        if _endAngle > .pi {
            let progress = 1 - (1 - _progress)/0.25
            _startAngle = (-.pi / 2) + (progress * .pi * 2)
        }
        
        let radius = self.animationRadius/2 - self.lineWidth/2
        let arcCenter = CGPoint(x: self.animationRadius/2, y: self.animationRadius/2)
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: CGFloat(radius),
                                startAngle: _startAngle,
                                endAngle: _endAngle,
                                clockwise: true)
        path.lineCapStyle = .round
        self._animationLayer.path = path.cgPath
    }
}

public extension PaymentLoadingHUD {
    static func showIn(view: UIView) -> PaymentLoadingHUD {
        self.hideIn(view: view)
        let hud = PaymentLoadingHUD(frame: view.bounds)
        hud.start()
        view.addSubview(hud)
        return hud
    }
    
    static func hideIn(view: UIView) {
        view.subviews.forEach { element in
            if element is PaymentLoadingHUD {
                (element as! PaymentLoadingHUD).hide()
                element.removeFromSuperview()
            }
        }
    }
    
    func start() {
        self._link.isPaused = false
    }
    
    func hide() {
        self._link.isPaused = true
        _progress = 0
    }
}

