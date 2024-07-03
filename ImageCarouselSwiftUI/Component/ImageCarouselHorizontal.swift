//
//  ImageCarouselHorizontal.swift
//  MovieStreamingUI
//
//  Created by Shameem Reza on 31/3/22.
//

import SwiftUI

/// - ImageCarouselHorizontal 组件使用示例
struct ImageCarouselHorizontalExample: View {
    struct SVMovie: Identifiable {
        var id = UUID().uuidString
        var image: String
    }
    
    @State private var movies: [SVMovie] = []
    @State var currentIndex: Int = 0
    
    var body: some View {
        ImageCarouselHorizontal(index: $currentIndex, items: movies) { movie in
            Image(movie.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding(.horizontal, 10)
        }
        .onAppear {
            initData()
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
    
    private func initData() {
        self.movies = (1...8).map({ SVMovie(image: "m\($0)") })
    }
}

/// - 轮播组件
struct ImageCarouselHorizontal<Content: View, T: Identifiable>: View {
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
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0) {
                ForEach(list){item in
                    content(item)
                        .frame(width: size.width, height: size.height)
                        .offset(y: getOffset(item: item, width: size.width))
                }
            }
            .padding(.horizontal, 0)
            .offset(x: (CGFloat(currentIndex) * -size.width) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: {value, out, _ in
                        out = (value.translation.width / 1.5)
                    })
                    .onEnded({value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / size.width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                        
                    })
                    .onChanged({value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / size.width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
        .ignoresSafeArea()
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

struct ImageCarouselHorizontalExample_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselHorizontalExample()
            .preferredColorScheme(.dark)
    }
}
