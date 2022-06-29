//
//  PaymentSuccessHUD.swift
//  PaymentHUD
//
//  Created by 李建航 on 2020/5/20.
//  Copyright © 2020 肇庆市华盈体育文化发展有限公司. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public class PaymentSuccessHUD: UIView {
    @IBInspectable open dynamic var animationRadius: CGFloat = 60 {
        didSet {
            if self.animationRadius != oldValue {
                self._animationLayer.bounds = CGRect(x: 0, y: 0, width: self.animationRadius, height: self.animationRadius)
            }
        }
    }
    
    @IBInspectable open dynamic var lineWidth: CGFloat = 4.0
    
    @IBInspectable open dynamic var strokeColor: UIColor = .init(red: 16/255, green: 142/255, blue: 233/255, alpha: 1.0)
    
    @IBInspectable open dynamic var circleDuration: Double = 0.5
    
    @IBInspectable open dynamic var checkDuration: Double = 0.2
    
    private lazy var _animationLayer: CALayer = {
        let animationLayer = CALayer()
        animationLayer.bounds = CGRect(x: 0, y: 0, width: self.animationRadius, height: self.animationRadius)
        animationLayer.position = self.center
        return animationLayer
    }()
    
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

private extension PaymentSuccessHUD {
    func circleAnimation() {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = self.strokeColor.cgColor
        circleLayer.lineWidth = self.lineWidth
        circleLayer.lineCap = .round
        circleLayer.frame = self._animationLayer.bounds
        self._animationLayer.addSublayer(circleLayer)
        
        let radius = self._animationLayer.bounds.size.width/2 - self.lineWidth/2
        let path = UIBezierPath(arcCenter: circleLayer.position,
                                radius: radius,
                                startAngle: -.pi / 2,
                                endAngle: .pi*3 / 2, clockwise: true)
        circleLayer.path = path.cgPath
        
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.duration = self.circleDuration
        circleAnimation.fromValue = 0.0
        circleAnimation.toValue = 1.0
        circleAnimation.setValue("circleAnimation", forKey: "animationName")
        circleLayer.add(circleAnimation, forKey: nil)
    }
    
    func checkAnimation() {
        let width = self._animationLayer.bounds.size.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width*2.7/10, y: width*5.4/10))
        path.addLine(to: CGPoint(x: width*4.5/10, y: width*7/10))
        path.addLine(to: CGPoint(x: width*7.8/10, y: width*3.8/10))
        
        let checkLayer = CAShapeLayer()
        checkLayer.path = path.cgPath
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.strokeColor = self.strokeColor.cgColor
        checkLayer.lineWidth = self.lineWidth
        checkLayer.lineCap = .round
        checkLayer.lineJoin = .round
        self._animationLayer.addSublayer(checkLayer)
        
        let checkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkAnimation.duration = self.checkDuration
        checkAnimation.fromValue = 0.0
        checkAnimation.toValue = 1.0
        checkAnimation.setValue("checkAnimation", forKey: "animationName")
        checkLayer.add(checkAnimation, forKey: nil)
    }
}

public extension PaymentSuccessHUD {
    static func showIn(view: UIView) -> PaymentSuccessHUD {
        self.hideIn(view: view)
        let hud = PaymentSuccessHUD(frame: view.bounds)
        hud.start()
        view.addSubview(hud)
        return hud
    }
    
    static func hideIn(view: UIView) {
        view.subviews.forEach { element in
            if element is PaymentSuccessHUD {
                (element as! PaymentSuccessHUD).hide()
                element.removeFromSuperview()
            }
        }
    }
    
    func start() {
        DispatchQueue.main.async { [unowned self] in
            self.circleAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8*circleDuration) { [unowned self] in
            self.checkAnimation()
        }
    }
    
    func hide() {
        self._animationLayer.sublayers?.forEach({ element in
            element.removeAllAnimations()
        })
    }
}
