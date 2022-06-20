//
//  Tag.swift
//  Garbage Classifier
//
//  Created by Kris on 6/20/22.
//

import SwiftUI

struct Tag: Identifiable, Hashable
{
    var id = UUID()
    var text: String
    var confidence: Int
    var size: CGFloat = 0
}
