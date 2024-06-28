//
//  ImageCarouselVertical.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/28.
//

import SwiftUI

/// - 轮播组件
struct ImageCarouselVertical<Content: View, T: Identifiable>: View {
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
            
            let height = proxy.size.height - (trialingSpace - spacing)
            
            VStack(spacing: spacing) {
                ForEach(list){item in
                    content(item)
                        .frame(height: proxy.size.height - trialingSpace)
                        .offset(y: getOffset(item: item, height: height))
                }
            }
            .padding(.horizontal, spacing)
            .offset(y: (CGFloat(currentIndex) * -height) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: {value, out, _ in
                        out = (value.translation.height / 1.5)
                    })
                    .onEnded({value in
                        let offsetX = value.translation.height
                        let progress = -offsetX / height
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                        
                    })
                    .onChanged({value in
                        let offsetX = value.translation.height
                        let progress = -offsetX / height
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
    
    func getOffset(item: T, height: CGFloat)->CGFloat {
        return CGFloat(getIndex(item: item))
    }
    
    func getIndex(item: T)-> Int {
        let index = list.firstIndex {currentItem in
            return currentItem.id == item.id
        } ?? 0
        return index
    }
}

struct ImageCarouselVertical_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
