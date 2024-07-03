//
//  ImageScrollView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/3.
//

import SwiftUI

/// - ImageScrollView 组件用法示例
struct ImageScrollViewExample: View {
    struct SVMovie: Identifiable {
        var id = UUID().uuidString
        var image: String
    }
    
    let images: [SVMovie] = (1...8).map({ SVMovie(image: "m\($0)") })
    @State var currentIndex: Int = 0
    
    var body: some View {
        ImageScrollView(items: images, currentIndex: $currentIndex, axis: .vertical) { movie in
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
                .background(.blue)
                .clipShape(Circle())
        }
    }
}

/// - 图片滚动组件（绑定当前图片的索引）
struct ImageScrollView<Content: View, T: Identifiable>: View {
    var list: [T]
    @Binding var currentIndex: Int
    var axis: Axis.Set
    var content: (T) -> Content
    
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    init(items: [T], currentIndex: Binding<Int>, axis: Axis.Set = .vertical, @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self._currentIndex = currentIndex
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(axis, showsIndicators: false) {
                Group {
                    if axis == .vertical {
                        VStack(spacing: 0) {
                            ForEach(list) { item in
                                content(item)
                                    .frame(width: size.width, height: size.height)
                            }
                        }
                    } else {
                        HStack(spacing: 0) {
                            ForEach(list) { item in
                                content(item)
                                    .frame(width: size.width, height: size.height)
                            }
                        }
                    }
                }
                .background(
                    GeometryReader {
                        let namedFrame = $0.frame(in: .named("scroll"))
                        Color.clear
                            .preference(key: ImageScrollPreferenceKey.self, value: axis == .vertical ? namedFrame.minY : namedFrame.minX)
                    }
                )
            }
            .scrollTargetBehavior(.paging)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ImageScrollPreferenceKey.self) { value in
                if axis == .vertical {
                    offsetY = value
                    currentIndex = abs(Int(((offsetY)/CGFloat(size.height))))
                } else {
                    offsetX = value
                    currentIndex = abs(Int(((offsetX)/CGFloat(size.width))))
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ImageScrollPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ImageScrollViewExample()
        .preferredColorScheme(.dark)
}
