//
//  TagView.swift
//  Garbage Classifier
//
//  Created by Kris on 6/20/22.
//

import SwiftUI

let screenWidthSize = UIScreen.main.bounds.width
var fontSize: CGFloat = 16

struct TagView: View
{
    @Binding var tags: [Tag]
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 15)
        {
            VStack(alignment: .leading, spacing: 10)
            {
                ForEach(getRow(), id:\.self) { rows in
                    HStack(spacing: 6)
                    {
                        ForEach(rows) { row in
                            RowView(tag: row)
                        }
                    }
                }
            }
            .frame(width: screenWidthSize - 80, alignment: .leading)
            .padding(.vertical)
        }
        .onChange(of: tags) { newValue in
            withAnimation(.easeInOut) {
                guard let last =  tags.last else { return }
                
                let font = UIFont.systemFont(ofSize: fontSize)
                let attributes = [NSAttributedString.Key.font: font]
                let size = (last.text as NSString).size(withAttributes: attributes)
                
                tags[getIndex(tag: last)].size = size.width
            }
        }
    }
    
    @ViewBuilder
    func RowView(tag: Tag) -> some View {
        Text("\(tag.confidence)% " + tag.text)
            .lineLimit(1)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .contentShape(Capsule())
            .contextMenu {
                Button {
                    tags.remove(at: getIndex(tag: tag))
                } label: {
                    Text("移除標籤")
                }
            }
    }
    
    func getIndex(tag: Tag) -> Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
    
    func getRow() -> [[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth: CGFloat = screenWidthSize - 90
        
        tags.forEach { tag in
            totalWidth += (tag.size + 125)
            
            if totalWidth > screenWidth {
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
}

struct TagView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
            .environmentObject(PhotoViewModel())
            .environmentObject(ClassifierViewModel())
    }
}
