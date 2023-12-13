
//
//  HalfCircleIndicator.swift
//
//
//  Created by Omar Altal on 12/12/2023.
//

import UIKit

public protocol HalfCircleIndicatorDelegate: AnyObject {
    func updatePosition(x: CGFloat, y: CGFloat, percent: CGFloat)
}

public class HalfCircleIndicator: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var progressOuterLayer = CAShapeLayer()
    private var fullSize: CGSize = .zero
    private var grayCircleSize: CGSize = .zero
    private var innerWhiteCircleSize: CGSize = .zero
    private var greenCircleSize: CGSize = .zero
    private var greenOuterCircleSize: CGSize = .zero
    private var value: CGFloat = 0.0
    
    weak var delegate: HalfCircleIndicatorDelegate?
    
    func getOutherGrayCircle() -> CAShapeLayer {
        let center = CGPoint(x: fullSize.width / 2, y: fullSize.height)
        let beizerPath = UIBezierPath()
        beizerPath.move(to: center)
        beizerPath.addArc(withCenter: center,
                          radius: grayCircleSize.width / 2,
                          startAngle: .pi,
                          endAngle: 2 * .pi,
                          clockwise: true)
        beizerPath.close()
        let innerGrayCircle = CAShapeLayer()
        innerGrayCircle.path = beizerPath.cgPath
        innerGrayCircle.fillColor = UIColor(red: 0.76, green: 0.78, blue: 0.82, alpha: 1).cgColor
        return innerGrayCircle
    }
    
    func getInnerWhiteCircle() -> CAShapeLayer {
        let center = CGPoint(x: fullSize.width / 2, y: fullSize.height)
        let beizerPath = UIBezierPath()
        beizerPath.move(to: center)
        beizerPath.addArc(withCenter: center,
                          radius: innerWhiteCircleSize.width / 2,
                          startAngle: .pi,
                          endAngle: 2 * .pi,
                          clockwise: true)
        beizerPath.close()
        let innerGrayCircle = CAShapeLayer()
        innerGrayCircle.path = beizerPath.cgPath
        innerGrayCircle.fillColor = UIColor.white.cgColor
        return innerGrayCircle
    }
    
    func getGreenCircle() -> CAShapeLayer {
        let center = CGPoint(x: fullSize.width / 2, y: fullSize.height)
        let beizerPath = UIBezierPath()
        beizerPath.move(to: center)
        beizerPath.addArc(withCenter: center,
                          radius: greenCircleSize.width / 2,
                          startAngle: .pi,
                          endAngle: .pi,
                          clockwise: true)
        beizerPath.close()
        let greenCircleLayer = CAShapeLayer()
        greenCircleLayer.path = beizerPath.cgPath
        greenCircleLayer.fillColor = UIColor(red: 0.17, green: 0.66, blue: 0.37, alpha: 0.17).cgColor
        return greenCircleLayer
    }
    
    func getGreenOuterCircle() -> CAShapeLayer {
        let center = CGPoint(x: fullSize.width / 2, y: fullSize.height)
        let beizerPath = UIBezierPath()
        beizerPath.move(to: center)
        beizerPath.addArc(withCenter: center,
                          radius: greenOuterCircleSize.width / 2,
                          startAngle: .pi,
                          endAngle: .pi,
                          clockwise: true)
        beizerPath.close()
        let greenCircleLayer = CAShapeLayer()
        greenCircleLayer.path = beizerPath.cgPath
        greenCircleLayer.fillColor = UIColor(red: 0.17, green: 0.66, blue: 0.37, alpha: 1).cgColor
        return greenCircleLayer
    }
    
    func drawShape(bounds: CGRect) {
        fullSize = bounds.size
        grayCircleSize = fullSize
        greenCircleSize = CGSize(width: bounds.width - 8.0, height: bounds.width - 8.0)
        greenOuterCircleSize = fullSize
        innerWhiteCircleSize = CGSize(width: greenCircleSize.width,
                                      height: greenCircleSize.width)
        
        let outerCicrcle = getOutherGrayCircle()
        let greenCircle = getGreenCircle()
        let innerWhiteCircle = getInnerWhiteCircle()
        let greenOuterCircle = getGreenOuterCircle()
        
        progressLayer = greenCircle
        progressOuterLayer = greenOuterCircle
        self.layer.addSublayer(outerCicrcle)
        self.layer.addSublayer(greenOuterCircle)
        self.layer.addSublayer(innerWhiteCircle)
        self.layer.addSublayer(greenCircle)
        
        self.layer.masksToBounds = true
    }
    
    func updateProgress(percent: CGFloat) {
        var newValue: CGFloat = 0.0
        if percent < 0.0 {
            newValue = 0.0
        } else if percent > 1.0 {
            newValue = 1.0
        } else {
            newValue = percent
        }
        
        value = newValue
        let width = fullSize.width
        let center = CGPoint(x: width / 2, y: width / 2)
        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = .pi + newValue * .pi
        
        let greenArchPath = UIBezierPath()
        greenArchPath.move(to: center)
        greenArchPath.addArc(withCenter: center,
                         radius: greenOuterCircleSize.width/2,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: true)
        greenArchPath.addQuadCurve(to: CGPoint(x: fullSize.width, y: fullSize.width), controlPoint: center)
        greenArchPath.close()
        
        let greenCirclePath = UIBezierPath()
        greenCirclePath.move(to: center)
        greenCirclePath.addArc(withCenter: center,
                    radius: greenCircleSize.width / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        greenCirclePath.close()
        
        let finalY: CGFloat = fullSize.height - greenArchPath.bounds.origin.y
        
        if percent > 0.5 {
            let point = prepareXPoint(percent: newValue)
            delegate?.updatePosition(x: point.x, y: point.y, percent: newValue)
        } else {
            let radius = fullSize.height * fullSize.height // We used X² + Y² = R² where R is raduis
            let yMultiple = finalY * finalY
            let calcOfRaduis = (radius - yMultiple).squareRoot()
            let finalX = fullSize.width/2 - calcOfRaduis
            delegate?.updatePosition(x: finalX, y: greenArchPath.bounds.origin.y, percent: newValue)
        }
        
        progressOuterLayer.path = greenArchPath.cgPath
        progressLayer.path = greenCirclePath.cgPath
    }
    
    func prepareXPoint(percent: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let newP = 1 - percent
        let width = fullSize.width
        let center = CGPoint(x: width / 2, y: width / 2)
        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = .pi + newP * .pi

        let outerPath = UIBezierPath()
        outerPath.move(to: center)
        outerPath.addArc(withCenter: center,
                         radius: greenOuterCircleSize.width/2,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: true)
        outerPath.addQuadCurve(to: CGPoint(x: fullSize.width, y: fullSize.width), controlPoint: center)
        outerPath.close()

        let finalY: CGFloat = fullSize.height - outerPath.bounds.origin.y
        let radius = fullSize.height * fullSize.height // We used X² + Y² = R² where R is raduis
        let yMultiple = finalY * finalY
        let calcOfRaduis = (radius - yMultiple).squareRoot()
        let finalX = fullSize.width/2 - calcOfRaduis
        
        return (finalX, outerPath.bounds.origin.y)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawShape(bounds: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
