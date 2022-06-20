//
//  Garbage_ClassifierApp.swift
//  Garbage Classifier
//
//  Created by Kris on 5/2/22.
//

import SwiftUI

@main
struct Garbage_ClassifierApp: App
{
    @StateObject var photoViewModel = PhotoViewModel()
    @StateObject var classifierViewModel = ClassifierViewModel()
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environmentObject(photoViewModel)
                .environmentObject(classifierViewModel)
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
