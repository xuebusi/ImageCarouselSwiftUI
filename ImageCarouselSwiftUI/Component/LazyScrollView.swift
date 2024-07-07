//
//  LazyScrollView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/2.
//


import SwiftUI

/// - LazyScrollView 组件用法示例
struct LazyScrollViewExample: View {
    
    struct Movie: Identifiable {
        var id = UUID().uuidString
        var thumbnail: String
    }
    
    /// - 保证项目资源中有名为m1～m8的这8张图片
    @State private var movies: [Movie] = []
    
    var body: some View {
        LazyScrollView(list: movies, axis: .vertical) { photo in
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
        }
        .onAppear {
            initData()
        }
    }
    
    private func initData() {
        self.movies = (1...8).map { .init(thumbnail: "m\($0)") }
    }
}


/// - 分页滚动组件（懒加载）
struct LazyScrollView<Content: View, T: Identifiable>: View {
    var list: [T]
    var content: (T) -> Content
    
    // 滚动方向
    let axis: Axis.Set
    
    @State private var size: CGSize = .zero
    
    init(list: [T],
         axis: Axis.Set = .vertical,
         @ViewBuilder content: @escaping (T) -> Content) {
        self.list = list
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axis, showsIndicators: false) {
                LazyStack(axis: axis) {
                    ForEach(list) { item in
                        content(item)
                            .frame(width: size.width, height: size.height)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onAppear {
                self.size = proxy.size
            }
        }
        .ignoresSafeArea()
    }
}

struct LazyStack<Content: View>: View {
    var axis: Axis.Set
    var content: () -> Content
    
    var body: some View {
        if axis == .vertical {
            LazyVStack(spacing: 0) {
                content()
            }
        } else {
            LazyHStack(spacing: 0) {
                content()
            }
        }
    }
}

#Preview {
    LazyScrollViewExample()
        .preferredColorScheme(.dark)
}
