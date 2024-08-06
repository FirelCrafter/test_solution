//
//  ImageFilter.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

enum ImageFilterType: String, CaseIterable, Identifiable {
    case sepia
    case noir
    case mono
    case vignette
    
    var id: String { self.rawValue }
    
    func filter() -> CIFilter {
        switch self {
        case .sepia:
            return CIFilter.sepiaTone()
        case .noir:
            return CIFilter.photoEffectNoir()
        case .mono:
            return CIFilter.photoEffectMono()
        case .vignette:
            return CIFilter.vignette()
        }
    }
}

class ImageFilter {
    private let context = CIContext()
    
    func applyFilter(to inputImage: UIImage, filterType: ImageFilterType, intensity: Double) -> UIImage? {
        guard let ciImage = CIImage(image: inputImage) else { return nil }
        
        let filter = filterType.filter()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        if filter.inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(intensity, forKey: kCIInputIntensityKey)
        }
        
        guard let outputImage = filter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
