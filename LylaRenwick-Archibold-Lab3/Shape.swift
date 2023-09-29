//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
extension UIBezierPath {
    func rotate(by angleRadians: CGFloat) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angleRadians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }

    // from https://stackoverflow.com/questions/20400396/reposition-resize-uibezierpath
    func scaleAroundCenter(factor: CGFloat) {
        let beforeCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
        self.apply(scaleTransform)

        let afterCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let diff = CGPoint(x: beforeCenter.x - afterCenter.x, y: beforeCenter.y - afterCenter.y)

        let translateTransform = CGAffineTransform(translationX: diff.x, y: diff.y)
        self.apply(translateTransform)
    }
}

class Shape: DrawingItem {
    
    var color: UIColor
    var origin: CGPoint
    var path: UIBezierPath!
    var type: Shape?
    var rotation: Bool
    var angle: CGFloat
    var sizeChange: Bool
    var amountChange: CGFloat
    
    public required init(origin: CGPoint, color: UIColor){
        self.color=color
        self.origin=origin
        self.rotation = false
        self.angle = 0.0
        self.sizeChange = false
        self.amountChange = 0.0
    }
    
    func draw() {
    }
    
    func contains(point: CGPoint) -> Bool {
        return path.contains(point)
    }
}


class Circle:Shape{
    
    var radius: CGFloat
    
    init(origin: CGPoint, color:UIColor, radius: CGFloat){
        self.radius=radius
        super.init(origin: origin, color: color)
    }
    required init(origin: CGPoint, color:UIColor){
        self.radius=0
        super.init(origin: origin, color: color)
    }
    override func draw(){
        self.color.setFill()
        self.path=UIBezierPath()
        self.path.addArc(withCenter: self.origin, radius: radius, startAngle: 0, endAngle: CGFloat(Float.pi*2), clockwise: true)
        
        if sizeChange == true{
            path.scaleAroundCenter(factor: amountChange)
        }
        
        if rotation == true {
            path.rotate(by: angle)
        }
        self.path.close()
        self.path.fill()
        
    }
    
    override func contains(point:CGPoint)->Bool{
        let distance=sqrt(pow(point.x-origin.x,2)+pow(point.y-origin.y,2))
        return distance <= radius
    }
    
    
}

class Square: Shape{
    
    var squareSide: CGFloat

    init(origin: CGPoint, color:UIColor, squareSide: CGFloat){
        self.squareSide=squareSide
        super.init(origin: origin, color: color)
    }
    
    required init(origin: CGPoint, color:UIColor){
        self.squareSide=0
        super.init(origin: origin, color: color)
    }
    override func draw(){
        //from https://stackoverflow.com/questions/38042933/swift-3-drawing-a-rectangle
        self.color.setFill()
        self.path=UIBezierPath(rect: CGRect(x: self.origin.x-(squareSide/1.5), y: self.origin.y-(squareSide/1.5), width: squareSide, height: squareSide))
        if sizeChange == true{
            path.scaleAroundCenter(factor: amountChange)
        }
        
        if rotation == true {
            path.rotate(by: angle)
        }
        self.path.fill()
        self.path.close()
    }
    
    override func contains(point:CGPoint)->Bool{
        let minX=origin.x-squareSide/2
        let minY=origin.y-squareSide/2
        let maxX=origin.x+squareSide/2
        let maxY=origin.y+squareSide/2
        
        return point.x >= minX &&
        point.x <= maxX &&
        point.y >= minY &&
        point.y <= maxY
    }
    
    
}

class Triangle: Shape{
    
    var triSide: CGFloat

    init(origin:CGPoint, color:UIColor, triSide: CGFloat){
        self.triSide=triSide
        super.init(origin: origin, color: color)
    }
    
    required init(origin: CGPoint, color:UIColor){
        self.triSide=0
        super.init(origin: origin, color: color)
    }
    override func draw(){
        //from https://www.appcoda.com/bezier-paths-introduction/
        self.color.setFill()
        self.path=UIBezierPath()
        
        let halftriSide=triSide/2
        path.move(to: CGPoint(x: self.origin.x, y: self.origin.y-halftriSide))
        path.addLine(to: CGPoint(x: self.origin.x-halftriSide, y: self.origin.y+halftriSide))
        path.addLine(to: CGPoint(x: self.origin.x+halftriSide, y: self.origin.y+halftriSide))
        
        if sizeChange == true{
            path.scaleAroundCenter(factor: amountChange)
        }
        
        if rotation == true {
            path.rotate(by: angle)
        }
        
        self.path.fill()
        self.path.close()
    }
    
    override func contains(point:CGPoint)->Bool{
    //from https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
        let top = CGPoint(x: origin.x, y: origin.y - triSide / 2)
        let p1 = CGPoint(x: origin.x - triSide / 2, y: origin.y + triSide / 2)
        let p2 = CGPoint(x: origin.x + triSide / 2, y: origin.y + triSide / 2)

        func sign(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
            return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
        }

        let d1 = sign(point, top, p1)
        let d2 = sign(point, p1, p2)
        let d3 = sign(point, p2, top)

        let hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0)
        let hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0)

        return !(hasNeg && hasPos)
    }
    
}
