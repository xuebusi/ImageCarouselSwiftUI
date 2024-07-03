//
//  ImageCarouselLayer.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

import SwiftUI

/// - ImageCarouselLayer 组件使用示例
struct ImageCarouselLayerExample: View {
    struct SVMovie: Identifiable {
        var id = UUID().uuidString
        var image: String
    }
    
    @State private var movies: [SVMovie] = []
    
    var body: some View {
        ZStack {
            if !movies.isEmpty {
                ImageCarouselLayer(items: $movies) { movie in
                    Image(movie.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                } onItemRemoved: { movie in
                    print("\(movie.image)移除了")
                }
            } else {
                Button("重置") {
                    self.movies = (1...8).map({ SVMovie(image: "m\($0)") })
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            self.movies = (1...8).map({ SVMovie(image: "m\($0)") })
        }
    }
}

/// - 垂直拖动移除元素组件
struct ImageCarouselLayer<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    @Binding var list: [T]
    
    @State private var currentIndex: Int = 0
    @State private var currentOffsetY: CGFloat = 0
    @State private var nextOpacity: Double = 0
    @State private var nextScale: CGFloat = 0.8
    @State private var alertOpacity: Double = 0
    
    private let onItemRemoved: (T) -> Void
    
    init(items: Binding<[T]>,
         @ViewBuilder content: @escaping (T)->Content,
         onItemRemoved: @escaping (T) -> Void) {
        self._list = items
        self.content = content
        self.onItemRemoved = onItemRemoved
    }
    
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            ZStack {
                if !list.isEmpty {
                    // 下一张图片
                    if currentIndex + 1 < list.count {
                        let nextIndex = currentIndex + 1
                        content(list[nextIndex])
                            .opacity(nextOpacity)
                            .scaleEffect(nextScale)
                    }
                    
                    // 当前图片
                    content(list[currentIndex])
                        .offset(x: 0, y: currentOffsetY)
                        .gesture(dragGesture())
                }
            }
            .frame(width: size.width, height: size.height)
        }
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                let screenHeight = UIScreen.main.bounds.height
                currentOffsetY = gesture.translation.height
                
                if currentIndex + 1 < list.count {
                    nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
                    nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
                }
            }
            .onEnded { gesture in
                let screenHeight = UIScreen.main.bounds.height
                let deltaY = gesture.translation.height
                
                if abs(deltaY) > screenHeight / 2 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
                        nextOpacity = 1
                        nextScale = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let item = list[currentIndex]
                        list.remove(at: currentIndex)
                        // 图片删除后的处理逻辑
                        self.onItemRemoved(item)
                        
                        if list.isEmpty {
                            currentOffsetY = 0
                            nextOpacity = 0
                            nextScale = 0.8
                            withAnimation(.easeInOut(duration: 0.3)) {
                                alertOpacity = 0
                            }
                        } else {
                            currentIndex = currentIndex % list.count
                            currentOffsetY = 0
                            nextOpacity = 0
                            nextScale = 0.8
                        }
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentOffsetY = 0
                        nextOpacity = 0
                        nextScale = 0.8
                    }
                }
            }
    }
}

struct ImageCarouselLayerExample_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselLayerExample()
            .preferredColorScheme(.dark)
    }
}
