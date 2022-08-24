//
//  DrawView.swift
//  Drawing
//
//  Created by 荒谷瑞穂 on 2022/08/16.
//

import CoreGraphics
import UIKit

struct Drawing {
    var color = UIColor.black
    var points = [CGPoint]()
}
class DrawView: UIImageView {
    
    var currentDrawing: Drawing?
    var finishedDrawings = [Drawing]()
    var currentColor = UIColor.black
    
    
    func draw(){
        for drawing in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
        
        if let drawing = currentDrawing {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if touch.view?.tag==1{
            let location = touch.location(in: self)
            currentDrawing = Drawing()
            currentDrawing?.color = currentColor
            currentDrawing?.points.append(location)
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view?.tag==1{
            
            let location = touch.location(in: self)
                    
            currentDrawing?.points.append(location)
            
            setNeedsDisplay()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var drawing = currentDrawing {
            let touch = touches.first!
            if touch.view?.tag==1{
                let location = touch.location(in: self)
                drawing.points.append(location)
                finishedDrawings.append(drawing)
                
            }
        }
        currentDrawing = nil
        draw()
        setNeedsDisplay()
    }
    
    func clear() {
        //finishedDrawings.removeAll()
        setNeedsDisplay()
    }
    
    func undo() {
        if finishedDrawings.count == 0 {
            return
        }
        finishedDrawings.remove(at: finishedDrawings.count - 1)
        setNeedsDisplay()
    }
    
    func setDrawingColor(color : UIColor){
        currentColor = color
    }
        
    func stroke(drawing: Drawing){
        
        //let resize = CGSize(width: framewidth, height: frameHight)
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsBeginImageContext(image.size)
        
        let path = UIGraphicsGetCurrentContext()!
        path.setLineWidth (10.0)
        path.setLineCap(.round)
        path.setLineJoin(.round)
            
        let begin = drawing.points[0];
        path.move(to: begin)
            
        if drawing.points.count > 1 {
            for i in 1...(drawing.points.count - 1) {
                let end = drawing.points[i]
                path.addLine(to: end)
            }
        }
        path.strokePath()
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        self.image=myImage
        
        UIGraphicsEndImageContext()
        
        }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
