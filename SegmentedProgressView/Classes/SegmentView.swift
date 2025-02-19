//
//  SegmentView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import UIKit

public protocol ProgressBarDelegate: class {
    
    func progressBar(willDisplayItemAtIndex index: Int)
    func progressBar(didDisplayItemAtIndex index: Int)

}

public protocol ProgressBarElementViewDelegate: class {
    
    func progressBar(didFinishWithElement element: SegmentView)

}

open class SegmentView: UIView {
    
    weak var delegate: ProgressBarElementViewDelegate?
    let item: ProgressItem
    
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    
    init(withItem item: ProgressItem!) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawEmpty() {
        
        let emptyColor = trackTintColor ?? .lightGray
        
        let emptyShape = CAShapeLayer()
        emptyShape.frame = self.bounds
        emptyShape.backgroundColor = emptyColor.cgColor
        emptyShape.cornerRadius = bounds.height / 2
        self.layer.addSublayer(emptyShape)
    }
    
    func animate() {
        
        let fillColor = progressTintColor ?? .gray
        
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height), cornerRadius: bounds.height / 2).cgPath
        let multiplicationFactor =  max(0, min(1, item.progress))
        let width = bounds.width * CGFloat(multiplicationFactor)
        var frame = bounds
        frame.size.width = width
        let endPath = UIBezierPath(roundedRect: frame, cornerRadius: bounds.height / 2)
        
        let filledShape = CAShapeLayer()
        filledShape.path = startPath
        filledShape.fillColor = fillColor.cgColor
        self.layer.addSublayer(filledShape)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.delegate?.progressBar(didFinishWithElement: self)
            self.item.handler?()
        })
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath.cgPath
        animation.duration = self.item.duration
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        
        filledShape.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
}
