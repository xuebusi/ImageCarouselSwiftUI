//
//  ImageCarouselVertical.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/28.
//

import SwiftUI

/// - ImageCarouselVertical 组件使用示例
struct ImageCarouselVerticalExample: View {
    struct SVMovie: Identifiable {
        var id = UUID().uuidString
        var image: String
    }
    
    let images: [SVMovie] = (1...8).map({ SVMovie(image: "m\($0)") })
    @State var currentIndex: Int = 0
    
    var body: some View {
        ImageCarouselVertical(index: $currentIndex, items: images) { movie in
            Image(movie.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding(.horizontal, 10)
        }
        .overlay {
            /// - 展示当前图片的索引
            Text("\(currentIndex)")
                .padding()
                .font(.title)
                .background(.blue)
                .clipShape(Circle())
        }
    }
}

/// - 轮播组件
struct ImageCarouselVertical<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    @Binding var index: Int
    
    init(index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            let height = proxy.size.height
            
            VStack(spacing: 0) {
                ForEach(list){item in
                    content(item)
                        .frame(height: proxy.size.height)
                        .offset(y: getOffset(item: item, height: height))
                }
            }
            .padding(.horizontal, 0)
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
        .ignoresSafeArea()
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

struct ImageCarouselVerticalExample_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselVerticalExample()
            .preferredColorScheme(.dark)
    }
}
