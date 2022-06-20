//
//  Image.swift
//  Garbage Classifier
//
//  Created by Kris on 6/19/22.
//

import Foundation
import SwiftUI

struct MyImage: Identifiable, Codable
{
    var id = UUID()
    var name: String
}

enum MyImageError: Error, LocalizedError {
    case readError
    case decodingError
    case encodingError
    case saveError
    case saveImageError
    case readImageError
    
    var errorDescription: String? {
        switch self {
        case .readError:
            return NSLocalizedString("Could not load MyImage.json", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your list of images", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save your image data", comment: "")
        case .saveError:
            return NSLocalizedString("Could not save the MyImage json file", comment: "")
        case .saveImageError:
            return NSLocalizedString("Could not save image", comment: "")
        case .readImageError:
            return NSLocalizedString("Could not load image", comment: "")
        }
    }
    
    struct ErrorType: Identifiable {
        let id = UUID()
        let error: MyImageError
        var message: String {
            error.localizedDescription
        }
        let button = Button("ok", role: .cancel) {}
    }
}
