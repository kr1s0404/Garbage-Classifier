//
//  ViewModel.swift
//  Garbage Classifier
//
//  Created by Kris on 6/19/22.
//

import SwiftUI

final class PhotoViewModel: ObservableObject
{
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    @Published var showCameraAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    
    func showPhotoPicker() {
        
        do {
            if source == .camera {
                try Picker.checkPermission()
            }
            showPicker = true
        } catch {
            showCameraAlert = true
            cameraError = Picker.CameraErrorType(error: error as! Picker.PickerError)
        }
    }
}
