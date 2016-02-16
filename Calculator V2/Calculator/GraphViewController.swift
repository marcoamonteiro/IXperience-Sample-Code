//
//  GraphViewController.swift
//  CalculatorV2
//
//  Created by Marco Monteiro
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    private var graphBrain: CalculatorBrain = CalculatorBrain() {
        didSet {
            graphView?.setNeedsDisplay()
        }
    }
    
    var program: AnyObject = "" {
        didSet {
            graphBrain.program = program
            graphView?.setNeedsDisplay()
            descriptionNeedsSetting=true
        }
    }
    
    private var descriptionNeedsSetting = false
    
    @IBOutlet weak var graphLabel: UILabel!
    
    
    //Setting up the graph view
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
            let recognizer = UITapGestureRecognizer(target: graphView, action: "tap:")
            recognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(recognizer)
            if(descriptionNeedsSetting) {
                graphLabel!.text="Graphing: " + graphBrain.description + "y"
                descriptionNeedsSetting=false
            }
        }
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        graphView?.setNeedsDisplay()
    }
    
    func getCorrespondingY(x: Double, origin: CGPoint, scale: CGFloat, screenWidth: Double) -> Double? {
        graphBrain.setVariableM((-Double(origin.x)+x)*Double(scale)/screenWidth)
        if let  y = graphBrain.evaluate() {
            if(y.isNaN||y.isInfinite) {
                return nil
            }
            return Double(origin.y) - y/Double(scale)*screenWidth
        } else {
            return nil
        }
    }
    
}
