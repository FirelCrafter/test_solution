//
//  HomeView.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import SwiftUI
import PencilKit

struct HomeView: View {
    @State private var image: UIImage?
    @State private var filterIntensity: Double = 0.5
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var canvasView = PKCanvasView()
    @State private var currentFilterType: ImageFilterType = .sepia
    @State private var scale: CGFloat = 1.0
    @State private var angle: Angle = .zero
    private let imageFilter = ImageFilter()

    var body: some View {
        NavigationView {
            VStack {
                DrawingView(image: $image, canvasView: $canvasView)
                    .scaleEffect(scale)
                    .rotationEffect(angle)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                self.scale = value
                            }
                            .simultaneously(with:
                                RotationGesture()
                                    .onChanged { value in
                                        self.angle = value
                                    }
                            )
                    )

                HStack {
                    Button(action: {
                        PermissionsManager.shared.checkPhotoLibraryPermission { granted in
                            if granted {
                                showImagePicker = true
                            } else {
                                // Handle the case where the user denies the permission
                            }
                        }
                    }) {
                        Text("Choose Photo")
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $inputImage)
                    }

                    Picker("Filter", selection: $currentFilterType) {
                        ForEach(ImageFilterType.allCases) { filter in
                            Text(filter.rawValue.capitalized).tag(filter)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button(action: {
                        if let inputImage = inputImage {
                            self.applyFilter()
                        }
                    }) {
                        Text("Apply Filter")
                    }

                    Button(action: saveImage) {
                        Text("Save Image")
                    }

                    Button(action: shareImage) {
                        Text("Share Image")
                    }
                }
            }
            .navigationBarTitle("Image Editor", displayMode: .inline)
            .onChange(of: inputImage) { _ in loadImage() }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = inputImage
    }

    func applyFilter() {
        guard let inputImage = inputImage else { return }
        image = imageFilter.applyFilter(to: inputImage, filterType: currentFilterType, intensity: filterIntensity)
    }

    func saveImage() {
        guard let image = image else { return }
        PermissionsManager.shared.checkPhotoLibraryPermission { granted in
            if granted {
                let combinedImage = combineImageAndDrawing(image: image, drawing: canvasView.drawing)
                UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
            } else {
                // Handle the case where the user denies the permission
            }
        }
    }

    func shareImage() {
        guard let image = image else { return }
        let combinedImage = combineImageAndDrawing(image: image, drawing: canvasView.drawing)
        let activityVC = UIActivityViewController(activityItems: [combinedImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

    func combineImageAndDrawing(image: UIImage, drawing: PKDrawing) -> UIImage {
        let imageSize = image.size
        let canvasSize = canvasView.bounds.size

        // Calculate the scale factor to fit the drawing within the image bounds
        let widthScale = imageSize.width / canvasSize.width
        let heightScale = imageSize.height / canvasSize.height
        let scale = min(widthScale, heightScale)

        let scaledDrawingSize = CGSize(width: canvasSize.width * scale, height: canvasSize.height * scale)
        let drawingImage = drawing.image(from: CGRect(origin: .zero, size: canvasSize), scale: UIScreen.main.scale)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: imageSize))

        // Center the drawing within the image bounds
        let drawingOrigin = CGPoint(x: (imageSize.width - scaledDrawingSize.width) / 2,
                                    y: (imageSize.height - scaledDrawingSize.height) / 2)
        drawingImage.draw(in: CGRect(origin: drawingOrigin, size: scaledDrawingSize))

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return combinedImage
    }
}
