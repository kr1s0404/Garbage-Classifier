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
    var tag: tag
}

struct tag
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
                        
                        let tagdata = d["tag"] as! [String:Any]
                        
                        return Post(id: d.documentID,
                                    name: d["name"] as? String ?? "",
                                    tag: tag(text: tagdata["text"] as? String ?? "",
                                             confidence: tagdata["confidence"] as? Int ?? 0))
                    }
                    print(self.posts)
                }
            }
        }
    }
}
