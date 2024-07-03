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
        .frame(width: 200, height: 300)
        .background(.pink)
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
            ScrollView(direction == .vertical ? .vertical : .horizontal, showsIndicators: false) {
                if direction == .vertical {
                    LazyVStack(spacing: 0) {
                        listView()
                    }
                } else {
                    LazyHStack(spacing: 0) {
                        listView()
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onAppear {
                self.containerSize = proxy.size
            }
        }
        .ignoresSafeArea()
    }
    
    private func listView() -> some View {
        ForEach(list) { item in
            content(item)
                .frame(width: containerSize.width, height: containerSize.height)
        }
    }
}

#Preview {
    LazyScrollViewExample()
        .preferredColorScheme(.dark)
}
