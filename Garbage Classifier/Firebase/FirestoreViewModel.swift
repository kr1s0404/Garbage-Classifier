//
//  FirestoreViewModel.swift
//  Garbage Classifier
//
//  Created by Kris on 6/26/22.
//

import SwiftUI
import Firebase

struct Post: Identifiable
{
    var id: String
    var name: String
    var imageURL: String
    var tag: [tag]
}

struct tag: Codable
{
    var text: String
    var confidence: Int
}


class FirestoreViewModel: ObservableObject
{
    @Published var posts = [Post]()
    
    init() {
        fetch()
    }
    
    func fetch() {
        
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.posts = snapshot.documents.map { d in

                        let tags = d["tags"] as! [[String:Any]]

                        return Post(id: d.documentID,
                                    name: d["name"] as? String ?? "",
                                    imageURL: d["imageURL"] as? String ?? "",
                                    tag: [tag(text: tags[0]["text"] as? String ?? "",
                                              confidence: tags[0]["confidence"] as? Int ?? 0),
                                          tag(text: tags[1]["text"] as? String ?? "",
                                                    confidence: tags[1]["confidence"] as? Int ?? 0),
                                          tag(text: tags[2]["text"] as? String ?? "",
                                                    confidence: tags[2]["confidence"] as? Int ?? 0)])
                    }
                    print(self.posts)
                }
            }
        }
    }
    
    func write(tags: [Tag], image: UIImage) {
        let db = Firestore.firestore()
        
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = ["name": "test",
                        "imageURL": imageURL,
                        "tags": [["text":tags[0].text, "confidence":tags[0].confidence],
                                 ["text":tags[1].text, "confidence":tags[1].confidence],
                                 ["text":tags[2].text, "confidence":tags[2].confidence]]] as [String : Any]
            
            db.collection("posts")
                .document()
                .setData(data) { error in
                    if let error = error {
                        print(error)
                        return
                    }
                    print("DEBUG: Did upload data to firestore")
                    self.fetch()
                }
        }
    }
}
