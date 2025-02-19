//
//  SegmentedProgressView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import Foundation

open class SegmentedProgressView: UIView, ProgressBarElementViewDelegate {
    
    public weak var delegate: ProgressBarDelegate?
    
    override open var frame: CGRect {
        didSet {
            redraw()
        }
    }
    
    public var progressTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var trackTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var itemSpace: Double? {
        didSet {
            redraw()
        }
    }
    
    public var items: [ProgressItem]? {
        didSet {
            redraw()
        }
    }
    
    var elementViews: [SegmentView] = []
    
    public init(withItems items: [ProgressItem]) {
        self.items = items
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    public init() {
        self.items = nil
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    fileprivate func redraw() {
        clear()
        draw()
    }
    
    fileprivate func clear() {
        
        elementViews.removeAll()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func draw() {
        
        let items = self.items ?? [ProgressItem(duration: 6) { print("finished 0") }]
        
        let horizontalSpace: Double = itemSpace ?? 6.0
        
        var elementWidth = ((Double(bounds.width) + horizontalSpace) / Double(items.count))
        elementWidth -= horizontalSpace
        
        if elementWidth <= 0 { return }
        
        var xOffset: Double = 0.0
        
        for item in items {
            
            let elementView = SegmentView(withItem: item)
            elementView.progressTintColor = self.progressTintColor
            elementView.trackTintColor = self.trackTintColor
            elementView.delegate = self
            elementView.frame = CGRect(x: xOffset, y: 0, width: elementWidth, height: Double(bounds.height))
            elementView.drawEmpty()
            self.addSubview(elementView)
            elementViews.append(elementView)
            xOffset += elementWidth + horizontalSpace
        }
        
        if let firstElement = elementViews.first {
            delegate?.progressBar(willDisplayItemAtIndex: 0)
            firstElement.animate()
        }
    }
    
    public func progressBar(didFinishWithElement element: SegmentView) {
        
        let elements = self.items ?? [ProgressItem(duration: 6) { print("finished 0") }]
        
        if var index = elementViews.firstIndex(of: element) {
            
            delegate?.progressBar(didDisplayItemAtIndex: index)
            
            index += 1
            
            if index < elements.count {
                let elementView = elementViews[index]
                delegate?.progressBar(willDisplayItemAtIndex: index)
                elementView.animate()
            }
        }
    }
}
