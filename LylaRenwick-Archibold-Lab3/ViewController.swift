//  ViewController.swift
//  LylaRenwick-Archibold-Lab3
//
//  Created by Lyla Renwick-Archibold on 9/29/23.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var currentShape: Shape?
    var touchPoint: CGPoint?
    var shapeColor: UIColor = .red
    var selectedShape: Shape?
    var indexes = [Int]();
    
    var shapeColors = [(UIColor.systemRed, "red"), (UIColor.systemOrange, "orange"), (UIColor.systemYellow, "yellow"), (UIColor.systemGreen, "green"), (UIColor.systemCyan, "cyan")]


    
    @IBOutlet weak var clearShapes: UIBarButtonItem!
    @IBOutlet weak var background: DrawingView!
    @IBOutlet weak var chooseAction: UISegmentedControl!
    @IBOutlet weak var chooseShape: UISegmentedControl!
    @IBOutlet weak var screenshotShape: UIBarButtonItem!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var randomColor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
    UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func clearShapes(_ sender: Any) {
        
        currentShape=nil
        background.items=[]

    }
    
    @IBAction func chooseAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            drawing()
        case 1:
            moving()
        case 2:
            erase()
        default:
            break
        }
    }
    
    
    @IBAction func redButton(_ sender: Any) {
        shapeColor = UIColor.systemRed
    }
    
    @IBAction func orangeButton(_ sender: Any) {
        shapeColor = UIColor.systemOrange
    }
    
    @IBAction func yellowButton(_ sender: Any) {
        shapeColor = UIColor.systemYellow
    }
    
    @IBAction func greenButton(_ sender: Any) {
        shapeColor = UIColor.systemGreen
    }
    
    @IBAction func blueButton(_ sender: Any) {
        shapeColor = UIColor.systemCyan
    }
    
    
    @IBAction func randomColor(_ sender: UIButton) {
        let randomColor = chooseRandomColor()
        shapeColor = randomColor
    }
    
    
    @IBAction func pinchShape(_ sender: UIPinchGestureRecognizer) {
        if let shape = selectedShape{
            switch sender.state{
            case .began:
                shape.sizeChange = true
            case .changed:
                shape.amountChange = sender.scale
                background.setNeedsDisplay()
            case .ended:
                //shape.sizeChange = false
                break
            default:
                break
            }
        }
    }
    
    //from https://www.reddit.com/r/SwiftUI/comments/lvc68q/how_do_i_structure_gestures_so_i_can_both_drag_an/
    @IBAction func rotateShape(_ sender: UIRotationGestureRecognizer) {
        if let shape = selectedShape {
            switch sender.state{
            case .began:
                shape.rotation = true
            case .changed:
                shape.angle = sender.rotation
                background.setNeedsDisplay()
            case .ended:
                //shape.rotation = false
                break
            default:
                break
            }
        }
    }
    
    
    //from https://stackoverflow.com/questions/25444609/screenshot-in-swift-ios
    @IBAction func screenshotShape(_ sender: UIBarButtonItem) {
        let renderer = UIGraphicsImageRenderer(size: background.frame.size)
        let image = renderer.image(actions: { context in background.layer.render(in: context.cgContext)})
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //from https://stackoverflow.com/questions/36253879/randomly-choosing-an-item-from-a-swift-array-without-repeating
    func chooseRandomColor() -> UIColor
    {
      if indexes.isEmpty{
        print("Filling indexes array")
          indexes = Array(0..<shapeColors.count)
      }
      let randomIndex = Int(arc4random_uniform(UInt32(indexes.count)))
      let anIndex = indexes.remove(at: randomIndex)
        
      return shapeColors[anIndex].0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint=(touches.first)!.location(in: background) as CGPoint
        
        if let touchPoint = touchPoint {
               selectedShape = background.itemAtLocation(touchPoint) as? Shape
           }
        
        switch chooseAction.selectedSegmentIndex{
        case 0:
            drawing()
        case 1:
            moving()
        case 2:
            erase()
        default:
            break
        }
   
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard touches.count==1, let touchPoint=touches.first?.location(in: background) else{
            print("moved touches here")
            return
        }
        
        currentShape = background.itemAtLocation(touchPoint) as? Shape
        print(touchPoint)
        currentShape?.origin=touchPoint
        background.setNeedsDisplay()
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let newShape=currentShape{
            background.items.append(newShape)
        }
    }
    
    func drawing(){
        
        guard let touchPoint=touchPoint else { return }
        switch chooseShape.selectedSegmentIndex{
        case 0:
            let square=Square(origin: touchPoint, color: shapeColor, squareSide: 50)
            currentShape=square
        
        case 1:
            let circle=Circle(origin: touchPoint, color: shapeColor, radius: 25)
            currentShape=circle
        
        case 2:
            let triangle=Triangle(origin: touchPoint, color: shapeColor, triSide: 50)
            currentShape=triangle
        default:
            break
        }
        
    }
    
    func erase() {
        let touchLocation = touchPoint ?? CGPoint.zero
        
        // Find the shape that contains the touch location
        if let shapeToRemove = background.itemAtLocation(touchLocation) as? Shape {
            if let indexToRemove = background.items.firstIndex(where: { $0 === shapeToRemove }) {
                background.items.remove(at: indexToRemove)
                background.setNeedsDisplay()
            }
        }
    }
    
    func moving(){
        
    }

    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
}
