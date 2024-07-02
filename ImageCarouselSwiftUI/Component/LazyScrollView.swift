//
//  LazyScrollView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/2.
//


import SwiftUI

/// - 分页滚动组件（懒加载）
struct LazyScrollView<Content: View, T: Identifiable>: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var list: [T]
    var content: (T) -> Content
    
    // 滚动方向
    let direction: Direction
    
    // 内容间距
    let padding: CGFloat
    
    init(list: [T],
         direction: Direction = .vertical,
         padding: CGFloat = 15,
         @ViewBuilder content: @escaping (T) -> Content) {
        self.list = list
        self.direction = direction
        self.padding = padding
        self.content = content
    }
    
    enum Direction {
        // 垂直滚动
        case vertical
        // 水平滚动
        case horizontal
    }
    
    var body: some View {
        if direction == .vertical {
            verticalScrollView
        } else {
            horizontalScrollView
        }
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
            .padding(direction == .horizontal ? padding : 0)
            .frame(width: screenWidth, height: screenHeight)
    }
}

/// - 预览测试示例
struct LazyScrollViewExample: View {
    
    struct Photo: Identifiable {
        var id = UUID().uuidString
        var thumbnail: String
    }
    
    /// - 保证项目资源中有名为m1～m8的这8张图片
    let photos: [Photo] = (1...8).map { .init(thumbnail: "m\($0)") }
    
    var body: some View {
        LazyScrollView(list: photos, direction: .horizontal, padding: 15) { photo in
            Image(photo.thumbnail)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
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


#Preview {
    LazyScrollViewExample()
        .preferredColorScheme(.dark)
}
