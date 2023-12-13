//
//  File.swift
//  
//
//  Created by Omar Altal on 13/12/2023.
//

import UIKit

public class HalfCircleContainer: UIView {
    
    private var progress: HalfCircleIndicator = HalfCircleIndicator(frame: CGRect(x: 0, y: 0, width: 152, height: 76)) // height should be half of the width (best ratio: width: 152, height: 76)
    private var circleView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
    
   public override init(frame: CGRect) {
         progress = HalfCircleIndicator(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        progress.delegate = self
        self.addSubview(progress)
        setupCircleView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        progress = HalfCircleIndicator(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        progress.delegate = self
        self.addSubview(progress)
        setupCircleView()
    }
    
    func setupCircleView() {
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = UIColor(red: 0.17, green: 0.66, blue: 0.37, alpha: 1)
        circleView.tag = 1111
        self.addSubview(circleView)
        updateProgress(percent: 0)
    }
    
    public func updateProgress(percent: CGFloat) {
        progress.updateProgress(percent: percent)
    }
}

extension HalfCircleContainer: HalfCircleIndicatorDelegate {
    public func updatePosition(x: CGFloat, y: CGFloat, percent: CGFloat) {
        if percent > 0.5 {
            circleView.center = CGPoint(x: self.frame.width - x - (progress.frame.origin.x), y: y + progress.frame.origin.y)
        } else {
            circleView.center = CGPoint(x: x + progress.frame.origin.x + 1, y: y + progress.frame.origin.y + 1)
        }
    }
}


