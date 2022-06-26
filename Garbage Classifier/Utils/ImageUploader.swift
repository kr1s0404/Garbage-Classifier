//
//  ImageUploader.swift
//  TWSKIN
//
//  Created by Kris on 5/28/22.
//

import SwiftUI
import Firebase

struct ImageUploader
{
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(fileName)")
        ref.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("DEBUG: Failed to upload image: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (imageURL, _) in
                guard let imageURL = imageURL?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
