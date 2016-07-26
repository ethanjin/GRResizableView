//
//  GRResizableView.swift
//  GRResizableView
//
//  Created by Ethan Jin on 7/26/16.
//  Copyright © 2016 EthanJin. All rights reserved.
//

import UIKit

class GRResizableView: UIView {
    
    var panGesture: UIPanGestureRecognizer! {
        willSet {
            if panGesture != nil {
                removeGestureRecognizer(panGesture)
            }
        }
        didSet {
            if panGesture != nil {
                addGestureRecognizer(panGesture)
            }
        }
    }
    
    var pinchGesture: UIPinchGestureRecognizer! {
        willSet {
            if pinchGesture != nil {
                removeGestureRecognizer(pinchGesture)
            }
        }
        didSet {
            if pinchGesture != nil {
                addGestureRecognizer(pinchGesture)
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor = UIColor.blackColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    var xDirection: Int = 0
    var yDirection: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func setUp() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        
        layer.backgroundColor = UIColor.redColor().CGColor
    }

    func panView(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .Began || gestureRecognizer.state == .Changed {
            let touchInThisView = gestureRecognizer.locationInView(self)
            
            if gestureRecognizer.state == .Began {
                xDirection = (touchInThisView.x < (self.borderWidth + 20)) ? -1 : (touchInThisView.x > (self.frame.size.width - (self.borderWidth + 20))) ? 1 : 0
                yDirection = (touchInThisView.y < (self.borderWidth + 20)) ? -1 : (touchInThisView.y > (self.frame.size.height - (self.borderWidth + 20))) ? 1 : 0
            }
            
            var tempFrame = self.frame
            let translation = gestureRecognizer.translationInView(self.superview)
            var xCenterOffset = translation.x
            var yCenterOffset = translation.y
            
            if xDirection != 0 { // User is touching an edge on sides.
                xCenterOffset = 0
                if xDirection > 0 { // Touch on right side edge, leave left side as is.
                    tempFrame.size.width = tempFrame.size.width + translation.x // Increase right by translation amount.
                } else { // Must be touching on left side edge.
                    tempFrame.origin.x = tempFrame.origin.x + translation.x // Move left by translation amount.
                    tempFrame.size.width = tempFrame.size.width - translation.x // Subtract negative translation value.
                }
            } else if yDirection != 0 { // User touching inside, ignore X offset.
                tempFrame.origin.x = self.frame.origin.x
                xCenterOffset = 0
            }
            
            if yDirection != 0 { // User is touching an edge, top or bottom.
                yCenterOffset = 0
                if yDirection > 0 { // Touch on bottom edge, leave top as is.
                    tempFrame.size.height = tempFrame.size.height + translation.y  // Increase by positive translation.
                } else { // Must be touch on top edge.
                    tempFrame.origin.y = tempFrame.origin.y + translation.y // Move top up by adding negative translation value.
                    tempFrame.size.height = tempFrame.size.height - translation.y // Subtract negative translation value.
                }
            } else if xDirection != 0 { // Then ignore Y offset if we are not in center.
                tempFrame.origin.y = self.frame.origin.y
                yCenterOffset = 0
            }
            
            tempFrame = forceFrameToStayVisible(tempFrame, centerOffset: CGPoint(x: xCenterOffset, y: yCenterOffset))
            self.frame = tempFrame
            
            gestureRecognizer.setTranslation(CGPoint.zero, inView: self.superview)
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            xDirection = 0
            yDirection = 0
            
//            var currentFrame = self.frame
//            self.reader?.imageBrowser(self, didMoveMark: (gestureRecognizer.view as! GFself).keywordId, toRect: currentFrame!)
        }
        
    }
    
    func forceFrameToStayVisible(originFrame: CGRect, centerOffset: CGPoint) -> CGRect {
        if centerOffset.x == 0 && centerOffset.y == 0 {
            let x = max(0, min(originFrame.origin.x, self.superview!.frame.size.width))
            let y = max(0, min(originFrame.origin.y, self.superview!.frame.size.height))
            let width = max(6, min(originFrame.size.width, self.superview!.frame.size.width - x))
            let height = max(6, min(originFrame.size.height, self.superview!.frame.size.height - y))
            
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = max(0, min(originFrame.origin.x + centerOffset.x, self.superview!.frame.size.width - originFrame.size.width))
            let y = max(0, min(originFrame.origin.y + centerOffset.y, self.superview!.frame.size.height - originFrame.size.height))
            let width = originFrame.size.width
            let height = originFrame.size.height
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
