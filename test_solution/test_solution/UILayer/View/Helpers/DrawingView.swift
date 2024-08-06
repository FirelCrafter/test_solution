//
//  DrawingView.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    @Binding var image: UIImage?
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        canvasView.drawingPolicy = .anyInput
        canvasView.frame = view.bounds
        canvasView.backgroundColor = .clear
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(imageView)
        view.addSubview(canvasView)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let imageView = uiView.subviews.first as? UIImageView {
            imageView.image = image
        }
        canvasView.frame = uiView.bounds
    }
}
