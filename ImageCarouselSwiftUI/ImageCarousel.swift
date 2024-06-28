//
//  ImageCarousel.swift
//  MovieStreamingUI
//
//  Created by Shameem Reza on 31/3/22.
//

import SwiftUI

/// - 轮播组件
struct ImageCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trialingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trialingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content) {
        
        self.list = items
        self.spacing = spacing
        self.trialingSpace = trialingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader{proxy in
            
            let width = proxy.size.width - (trialingSpace - spacing)
            
            HStack(spacing: spacing) {
                ForEach(list){item in
                    content(item)
                        .frame(width: proxy.size.width - trialingSpace)
                        .offset(y: getOffset(item: item, width: width))
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: {value, out, _ in
                        out = (value.translation.width / 1.5)
                    })
                    .onEnded({value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                        
                    })
                    .onChanged({value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
    
    func getOffset(item: T, width: CGFloat)->CGFloat {
        return CGFloat(getIndex(item: item))
    }
    
    func getIndex(item: T)-> Int {
        let index = list.firstIndex {currentItem in
            return currentItem.id == item.id
        } ?? 0
        return index
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
