//
//  GraphView.swift
//  CalculatorV2
//
// Marco Monteiro
//

import UIKit

protocol GraphViewDataSource {
//    func graphView(graphView:GraphView, yCorrespondingToX x:Double) -> Double
    
    func getCorrespondingY(GraphViewx: Double, origin: CGPoint, scale: CGFloat, screenWidth: Double) -> Double?
}


@IBDesignable


class GraphView: UIView
{
    @IBInspectable
    var scale: CGFloat = 20 { didSet { setNeedsDisplay() } }
    var hasBeenSet = false
    var axesDrawer: AxesDrawer = AxesDrawer()
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var origin: CGPoint = CGPoint(x: 0,y: 0) { didSet { setNeedsDisplay() } }
    
    var dataSource: GraphViewDataSource?
    
    override func drawRect(rect: CGRect)
    {
        if !hasBeenSet {
            origin = CGPoint(x: rect.width/2, y: rect.height/2)
            hasBeenSet = true
        }
        axesDrawer.drawAxesInRect(rect, origin: origin, pointsPerUnit: rect.width/scale)
        drawFunction(rect)
    }

    //Allows for scaling of graph
    func scale(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .Changed {
            scale /= gesture.scale
            gesture.scale = 1
        }
    }
    
    //Allows for panning of graph
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            origin.x = origin.x + translation.x
            origin.y = origin.y + translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
            
        }
    }
    
    //Tap to pan to a location
    func tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
    
    //Graphs the function
    func drawFunction(rect: CGRect) {
        let xRange = scale
        let pointOnGraph = UIBezierPath()
        var hasAStartingPoint = false
        if let y = dataSource!.getCorrespondingY(0, origin: origin, scale: scale,  screenWidth: Double(rect.width)){
            let startingPoint = CGPoint(x: 0.0, y: y)
            pointOnGraph.moveToPoint(startingPoint)
            hasAStartingPoint=true;
        }
        color.set()
        for(var x = 0.0; x < (Double)(rect.width); x++) {
            if let y = dataSource!.getCorrespondingY(x, origin: origin, scale: scale,  screenWidth: Double(rect.width)) {
                let nextPointOnGraph = CGPoint(x: x, y: y)
                if hasAStartingPoint {
                    pointOnGraph.addLineToPoint(nextPointOnGraph)
                } else {
                    hasAStartingPoint = true
                    pointOnGraph.moveToPoint(nextPointOnGraph)
                }
            } else {
                hasAStartingPoint = false
            }
        }
        hasAStartingPoint=false
        pointOnGraph.lineWidth = 1
        pointOnGraph.stroke()
    }

}
