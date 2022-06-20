//
//  ImagePicker.swift
//  Garbage Classifier
//
//  Created by Kris on 5/2/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable
{
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var uiImage: UIImage?
    @Binding var isPresenting: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context)
    {
        
    }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
    
    typealias UIViewControllerType = UIImagePickerController
    
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let parent: ImagePicker
    
    init(_ imagePicker: ImagePicker) {
        self.parent = imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        parent.uiImage = info[.originalImage] as? UIImage
        
        parent.isPresenting = false
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        parent.isPresenting = false
    }
    
}
