//
//  PermissionsManager.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import Foundation
import Photos
import AVFoundation

class PermissionsManager {
    
    static let shared = PermissionsManager()
    
    private init() {}
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        case .authorized:
            completion(true)
        case .denied, .restricted, .limited:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}
