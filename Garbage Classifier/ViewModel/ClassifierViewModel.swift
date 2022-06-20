//
//  ClassifierViewModel.swift
//  Garbage Classifier
//
//  Created by Kris on 6/19/22.
//

import SwiftUI
import CoreML
import Vision
import CoreImage

final class ClassifierViewModel: ObservableObject
{
    @Published var prediction: String = ""
    @Published var tags: [Tag] = []
    
    func detect(uiImage: UIImage) {
        do {
            guard let ciImage = CIImage(image: uiImage) else { return }
            let config = MLModelConfiguration()
            let model = try VNCoreMLModel(for: GarbageClassifier(configuration: config).model)
            
            let request = VNCoreMLRequest(model: model)
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            try? handler.perform([request])
            
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            var displayText = ""
            for result in results.prefix(5) {
                displayText += "\(Int(result.confidence * 100))% " + result.identifier + "\n"
                self.tags.append(Tag(text: result.identifier, confidence: Int(result.confidence * 100)))
            }
            self.prediction = displayText
            print(displayText)
        } catch {
            print(error)
        }
    }
}
