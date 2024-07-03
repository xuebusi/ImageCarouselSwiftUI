//
//  LazyScrollView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/2.
//


import SwiftUI

/// - LazyScrollView 组件用法示例
struct LazyScrollViewExample: View {
    
    struct Photo: Identifiable {
        var id = UUID().uuidString
        var thumbnail: String
    }
    
    /// - 保证项目资源中有名为m1～m8的这8张图片
    let photos: [Photo] = (1...8).map { .init(thumbnail: "m\($0)") }
    
    var body: some View {
        LazyScrollView(list: photos, direction: .horizontal) { photo in
            Image(photo.thumbnail)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding(15)
                .onAppear {
                    print("\(photo.thumbnail)加载😊")
                }
                .onDisappear {
                    print("\(photo.thumbnail)卸载😭😭")
                }
                .overlay {
                    /// - 显示照片名称
                    Text("\(photo.thumbnail)")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(.blue)
                }
        }
    }
}


/// - 分页滚动组件（懒加载）
struct LazyScrollView<Content: View, T: Identifiable>: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var list: [T]
    var content: (T) -> Content
    
    // 滚动方向
    let direction: Direction
    
    @State private var containerSize: CGSize = .zero
    
    init(list: [T],
         direction: Direction = .vertical,
         @ViewBuilder content: @escaping (T) -> Content) {
        self.list = list
        self.direction = direction
        self.content = content
    }
    
    enum Direction {
        // 垂直滚动
        case vertical
        // 水平滚动
        case horizontal
    }
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if direction == .vertical {
                    verticalScrollView
                } else {
                    horizontalScrollView
                }
            }
            .onAppear {
                self.containerSize = proxy.size
            }
        }
        .ignoresSafeArea()
    }
    
    var verticalScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(list.indices, id: \.self) { index in
                    listItemView(index)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
    }
    
    var horizontalScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(list.indices, id: \.self) { index in
                    listItemView(index)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
    }
    
    func listItemView(_ index: Int) -> some View {
        content(list[index])
            .frame(width: containerSize.width, height: containerSize.height)
    }
}

#Preview {
    LazyScrollViewExample()
        .preferredColorScheme(.dark)
}
