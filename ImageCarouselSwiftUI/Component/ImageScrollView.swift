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
    
    @State private var movies: [SVMovie] = []
    @State var currentIndex: Int = 0
    
    var body: some View {
        ImageScrollView(items: movies, currentIndex: $currentIndex, axis: .horizontal) { movie in
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

struct HVStack<Content: View>: View {
    var axis: Axis.Set
    var content: () -> Content
    
    var body: some View {
        if axis == .vertical {
            VStack {
                content()
            }
        } else {
            HStack {
                content()
            }
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
    
    init(items: [T], currentIndex: Binding<Int>, axis: Axis.Set = .horizontal, @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self._currentIndex = currentIndex
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(axis, showsIndicators: false) {
                HVStack(axis: axis) {
                    ForEach(list) { item in
                        content(item)
                            .frame(width: size.width, height: size.height)
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
                print("\(String(format: "%.0f", abs(value)))")
                if axis == .vertical {
                    offsetY = value
                    if isDivisible(Int(offsetY), by: Int(size.height)) {
                        currentIndex = abs(Int(((offsetY)/CGFloat(size.height))))
                    }
                } else {
                    offsetX = value
                    if isDivisible(Int(offsetX), by: Int(size.width)) {
                        currentIndex = abs(Int(((offsetX)/CGFloat(size.width))))
                    }
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

/// - 判断是否可以整除
func isDivisible(_ dividend: Int, by divisor: Int) -> Bool {
    return dividend % divisor == 0
}

#Preview {
    ImageScrollViewExample()
        .preferredColorScheme(.dark)
}
