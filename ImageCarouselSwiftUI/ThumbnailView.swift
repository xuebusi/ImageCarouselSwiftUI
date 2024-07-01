//
//  ThumbnailView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/1.
//

import SwiftUI

/// - 测试缩略图居中显示(不完美)
struct ThumbnailView: View {
    @State private var currentIndex: Int = 0
    let screenWidth = UIScreen.main.bounds.width
    let thumbnailWidth: CGFloat = 50
    let spacing: CGFloat = 10
    
    // 计算缩略图总宽度
    var totalWidth: CGFloat {
        return CGFloat(movieList.count) * thumbnailWidth + CGFloat(movieList.count - 1) * spacing
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(movieList.indices, id: \.self) { index in
                        Image(movieList[index].thumb)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: thumbnailWidth, height: thumbnailWidth)
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
                .frame(width: totalWidth < screenWidth ? screenWidth : totalWidth)
                .background(Color.blue.opacity(0.5))
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
    ThumbnailView()
}
