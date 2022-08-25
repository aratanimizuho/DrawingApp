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
    var contexCache:[UIImage]=[]
    
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
        
        if contexCache.count==0 {
            
            if self.image != nil {
                contexCache.append(self.image!)
            }
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
        contexCache.append(self.image!)
        setNeedsDisplay()
    }
    
    func clear() {
        finishedDrawings.removeAll()
        setNeedsDisplay()
    }
    
    func undo() {
        
        switch contexCache.count{
        case (0...1):
            return
        case 1:
            clear()
        default:
            contexCache.removeLast()
            self.image = contexCache.last
            setNeedsDisplay()
        }
        
    }
    
    func setDrawingColor(color : UIColor){
        currentColor = color
    }
        
    func stroke(drawing: Drawing){
        
        if contexCache.count != 0{
            self.image=contexCache[contexCache.count-1]
        }
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        let path = UIGraphicsGetCurrentContext()!
        
        self.layer.render(in: path)
        
        path.setLineWidth (10.0)
        path.setLineCap(.round)
        path.setLineJoin(.round)
        path.setStrokeColor(currentColor.cgColor)

        let begin = drawing.points[0];
        path.move(to: begin)

        if drawing.points.count > 1 {
            for i in 1...(drawing.points.count - 1) {
                let end = drawing.points[i]
                path.addLine(to: end)
            }
        }
        path.strokePath()
        
        self.image=UIGraphicsGetImageFromCurrentImageContext()!
        
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
