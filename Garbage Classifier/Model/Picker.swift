//
//  Picker.swift
//  Garbage Classifier
//
//  Created by Kris on 6/19/22.
//

import SwiftUI
import AVFoundation

enum Picker {
    enum Source: String {
        case library, camera
    }
    
    enum PickerError: Error, LocalizedError {
        case unavaliable
        case restricted
        case denied
        
        var errorDescription: String? {
            switch self {
            case .unavaliable:
                return NSLocalizedString("No Camera on this device", comment: "")
            case .restricted:
                return NSLocalizedString("You are not allowed this app to open camera", comment: "")
            case .denied:
                return NSLocalizedString("You are not allowed this app to open camera", comment: "")
            }
        }
    }
    
    static func checkPermission() throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .restricted:
                throw PickerError.restricted
            case .denied:
                throw PickerError.denied
            default:
                break
            }
        } else {
            throw PickerError.unavaliable
        }
    }
    
    struct CameraErrorType {
        let error: Picker.PickerError
        var message: String {
            error.localizedDescription
        }
        
        let button = Button("ok", role: .cancel) {}
    }
}
