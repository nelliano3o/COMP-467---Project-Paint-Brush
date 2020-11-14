//
//  ViewController.swift
//  DrawingApp
//
//  Created by Neli Shahapuni on 11/7/20.
//  Copyright © 2020 Neli Shahapuni. All rights reserved.
//

import UIKit
import PencilKit

class ViewController: UIViewController, PKCanvasViewDelegate,PKToolPickerObserver{
    @IBOutlet weak var pencilFingerButton: UIBarButtonItem!
    
    @IBOutlet weak var canvasView: PKCanvasView!
    
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHight: CGFloat = 500
    
    var drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.allowsFingerDrawing = true
        
        if let window = parent?.view.window,
            let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let canvasScale = canvasView.bounds.width / canvasWidth
        
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        
        updateContentSizeForDrawing()
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func toogleFingerOrPencil (_ sender: Any) {
        canvasView.allowsFingerDrawing.toggle()
        pencilFingerButton.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
        
    }
    

    @IBAction func saveDrawingToCameraRoll(_ sender: Any) {
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        updateContentSizeForDrawing()
    }
    
    func updateContentSizeForDrawing() {
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }
    
}

