//
//  ContentView.swift
//  Garbage Classifier
//
//  Created by Kris on 5/2/22.
//

import SwiftUI

struct ContentView: View
{
    @EnvironmentObject var photoViewModel: PhotoViewModel
    @EnvironmentObject var classifierViewModel: ClassifierViewModel
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                if let image = photoViewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .cornerRadius(10)
                        .onAppear {
                            classifierViewModel.detect(uiImage: image)
                        }
                        .onChange(of: image) { newImage in
                            classifierViewModel.detect(uiImage: newImage)
                            classifierViewModel.tags.removeSubrange(0...4)
                        }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.horizontal)
                }
                
                TagView(tags: $classifierViewModel.tags)
                    .frame(height: 280)
                
                Button {
                    if let image = photoViewModel.image {
                        firestoreViewModel.write(tags: classifierViewModel.tags, image: image)
                    }
                } label: {
                    Text("上傳")
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        photoViewModel.source = .library
                        photoViewModel.showPhotoPicker()
                    } label: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        photoViewModel.source = .camera
                        photoViewModel.showPhotoPicker()
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                }
            }
            .sheet(isPresented: $photoViewModel.showPicker, onDismiss: nil) {
                ImagePicker(sourceType: photoViewModel.source == .library ? .photoLibrary : .camera,
                            uiImage: $photoViewModel.image,
                            isPresenting: $photoViewModel.showPicker)
                    .ignoresSafeArea()
            }
            .alert("Error", isPresented: $photoViewModel.showCameraAlert, presenting: photoViewModel.cameraError) { error in
                error.button
            } message: { error in
                Text(error.message)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
            .environmentObject(PhotoViewModel())
            .environmentObject(ClassifierViewModel())
            .environmentObject(FirestoreViewModel())
    }
}
