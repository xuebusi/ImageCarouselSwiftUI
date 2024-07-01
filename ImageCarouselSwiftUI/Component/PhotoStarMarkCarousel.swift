//
//  PhotoStarMarkCarousel.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/30.
//

import SwiftUI

/// 照片星标组件：上下滑动移除图片，左右滑动切换图片
struct PhotoStarMarkCarousel<Content: View, ThumbnailContent: View, Movie: Identifiable>: View {
    @Binding var currentIndex: Int
    var content: (Movie) -> Content
    var thumbnailContent: (Movie) -> ThumbnailContent
    @Binding var list: [Movie]
    private let onItemRemoved: (Movie) -> Void
    
    // 屏幕宽度
    private let screenWidth = UIScreen.main.bounds.width
    // 屏幕高度
    private let screenHeight = UIScreen.main.bounds.height
    // 拖动偏移量
    @State private var offset: CGSize = .zero
    // 缩放
    @State private var scale: Double = 1
    // 透明度
    @State private var opacity: Double = 1
    // 旋转角度
    @State private var rotation: Double = .zero
    // 星级缩放
    @State private var ratingScale: Double = 0
    // 星级透明度
    @State private var ratingOpacity: Double = 0
    // 是否隐藏状态栏
    @State private var isHiddenStatusBar: Bool = false
    // 拖动方向
    @State private var direction: Direction = .none
    
    enum Direction {
        // 无方向
        case none
        // 向右
        case letf
        // 向左
        case right
        // 向上
        case top
        // 向下
        case bottom
        
        // 是否水平方向
        var isVertical: Bool {
            if case .top = self {
                return true
            } else if case .bottom = self {
                return true
            }
            return false
        }
        
        // 是否垂直方向
        var isHorizontal: Bool {
            if case .letf = self {
                return true
            } else if case .right = self {
                return true
            }
            return false
        }
    }
    
    init(items: Binding<[Movie]>,
         currentIndex: Binding<Int>,
         @ViewBuilder content: @escaping (Movie) -> Content,
         @ViewBuilder thumbnailContent: @escaping (Movie) -> ThumbnailContent,
         onItemRemoved: @escaping (Movie) -> Void) {
        self._list = items
        self._currentIndex = currentIndex
        self.content = content
        self.thumbnailContent = thumbnailContent
        self.onItemRemoved = onItemRemoved
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let size = geometry.size
                HStack(spacing: 0) {
                    ForEach(list.indices, id: \.self) { index in
                        content(list[index])
                            .frame(width: size.width)
                            .frame(maxHeight: .infinity)
                            .background(Color.black.opacity(0.0000001)) // 图片以外的不可见区域也允许拖动
                            .offset(offset)
                            .rotationEffect(Angle(degrees: currentIndex == index ? rotation : 0))
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            .scaleEffect(scale)
                            .opacity(opacity)
                            .gesture(dragGesture(for: index)) // 为每张图片添加拖动手势
                    }
                }
                .frame(width: size.width * CGFloat(list.count), alignment: .leading)
                .frame(maxHeight: .infinity)
                .offset(x: -CGFloat(currentIndex) * size.width)
                .animation(.easeInOut(duration: 0.3), value: currentIndex)
            }
            .overlay(alignment: .bottom) {
                ThumbnailListView(images: $list, currentIndex: $currentIndex, thumbnailContent: thumbnailContent)
            }
        }
        .statusBarHidden(isHiddenStatusBar) // 控制状态栏的隐藏
        .overlay(ratingOverlay) // 显示评分叠加视图
    }
    
    /// - 评分叠加视图
    private var ratingOverlay: some View {
        Group {
            if direction == .bottom {
                Text("-1星")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Color.red)
                    .clipShape(Circle())
            } else if direction == .top {
                Text("+1星")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Color.green)
                    .clipShape(Circle())
            }
        }
        .scaleEffect(ratingScale)
        .opacity(ratingOpacity)
    }
    
    /// - 创建拖动手势
    private func dragGesture(for index: Int) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                let deltaX = gesture.translation.width
                let deltaY = gesture.translation.height
                
                if direction == .none {
                    // 当无方向时设置拖动方向，拖动过程中方向只设置一次
                    if abs(deltaX) > abs(deltaY) {
                        direction = deltaX > 0 ? .right : .letf
                    } else {
                        direction = deltaY > 0 ? .bottom : .top
                    }
                }
                
                if index == currentIndex {
                    // 根据手势方向决定图片的移动方向
                    if direction.isHorizontal {
                        // 水平拖动时只在x轴移动
                        offset = CGSize(width: deltaX, height: 0)
                    } else if direction.isVertical {
                        withAnimation(.easeInOut(duration: 0.3)) { isHiddenStatusBar = true }
                        // 垂直拖动时只在y轴移动
                        offset = CGSize(width: 0, height: deltaY)
                        rotation = abs(deltaY) * 0.036 // 设置旋转角度
                        
                        if abs(deltaY) < (screenHeight/3) {
                            ratingScale = abs(offset.height) * 0.0038
                            ratingOpacity = Double(abs(offset.height)/(screenHeight/3))
                        }
                    }
                }
            }
            .onEnded { gesture in
                let dragXAmount = abs(gesture.translation.width)
                let dragYAmount = abs(gesture.translation.height)
                
                if index == currentIndex {
                    if direction.isVertical && dragYAmount > screenHeight / 3 {
                        // 处理垂直拖动
                        handleVerticalDrag(gesture)
                    } else if direction.isHorizontal && dragXAmount > screenWidth / 6 {
                        // 处理水平拖动
                        handleHorizontalDrag(gesture)
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            offset = .zero
                            rotation = .zero
                        }
                    }
                }
                
                // 拖动结束后设置拖动方向为无方向
                direction = .none
                withAnimation(.easeInOut(duration: 0.3)) { isHiddenStatusBar = false }
            }
    }
    
    /// - 处理垂直拖动
    private func handleVerticalDrag(_ gesture: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = CGSize(width: 0, height: direction == .top ? -screenHeight : screenHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 动画结束后再进行移除操作
            if !list.isEmpty {
                let item = list[currentIndex]
                list.remove(at: currentIndex)
                onItemRemoved(item)
                currentIndex = min(currentIndex, list.count - 1)
                /// - 索引更新后重置新图片的位置等参数
                offset = .zero
                rotation = .zero
                scale = 0
                opacity = 0
                
                withAnimation(.spring(duration: 0.2)) {
                    scale = 1
                    opacity = 1
                }
            }
        }
    }
    
    /// - 处理水平拖动
    private func handleHorizontalDrag(_ gesture: DragGesture.Value) {
        if gesture.translation.width > 0 {
            currentIndex = max(0, currentIndex - 1)
        } else {
            currentIndex = min(currentIndex + 1, list.count - 1)
        }
        /// - 索引更新后重置新图片的位置等参数
        withAnimation {
            offset = .zero
            rotation = .zero
        }
    }
    
    /// - 更改当前图片索引
    private func changeIndex(by offset: Int) {
        currentIndex = min(max(0, currentIndex + offset), list.count - 1)
    }
    
    /// - 移除当前图片
    private func removeCurrentImage() {
        if !list.isEmpty {
            let item = list[currentIndex]
            list.remove(at: currentIndex)
            onItemRemoved(item)
            currentIndex = min(currentIndex, list.count - 1)
        }
    }
}

private struct ThumbnailListView<Movie: Identifiable, ThumbnailContent: View>: View {
    @Binding var images: [Movie]
    @Binding var currentIndex: Int
    var thumbnailContent: (Movie) -> ThumbnailContent

    init(images: Binding<[Movie]>, currentIndex: Binding<Int>, @ViewBuilder thumbnailContent: @escaping (Movie) -> ThumbnailContent) {
        self._images = images
        self._currentIndex = currentIndex
        self.thumbnailContent = thumbnailContent
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(images.indices, id: \.self) { index in
                        thumbnailContent(images[index])
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.white, lineWidth: currentIndex == index ? 2 : 0)
                            }
                            .onTapGesture {
                                withAnimation {
                                    currentIndex = index
                                }
                            }
                            .id(index)
                    }
                }
                .padding(.horizontal, 10)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
                .onAppear { proxy.scrollTo(0) }
                .onChange(of: currentIndex) { _, _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo(currentIndex, anchor: .center)
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
