//
//  SwiftUIView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

//import SwiftUI
//
//struct SwiftUIView: View {
//    // 当前图片的索引（默认显示第1张图片）
//    @State var currentIndex: Int = 0
//    // 当前图片的y轴偏移量
//    @State var currentOffsetY: CGFloat = 0
//    
//    // 下一张图片的索引（默认显示第2张图片）
//    @State var nextIndex: Int = 1
//    // 下一张图片的透明度（默认不显示）
//    @State var nextOpacity: Double = 0
//    // 下一张图片的缩放
//    @State var nextScale: CGFloat = 0.8
//    
//    // 电影图片
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    // 电影图片列表
//    var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            // 下一张图片
//            Image(movies[nextIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .opacity(nextOpacity)
//                .scaleEffect(nextScale)
//            
//            // 当前图片
//            Image(movies[currentIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .offset(x: 0, y: currentOffsetY)
//                .onAppear {
//                    // 根据当前图片索引更新下一张图片的索引
//                    if currentIndex + 1 < movies.count - 1 {
//                        self.nextIndex = currentIndex + 1
//                    }
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged({ gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            // 更新当前图片的y轴偏移量
//                            currentOffsetY = gesture.translation.height
//                            // 更新下一张图片的透明度，随着当前图片的移动，下一张图片逐渐由透明变为不透明
//                            nextOpacity = abs(currentOffsetY)/(screenHeight*0.9)
//                        })
//                        .onEnded({ gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            let deltaY = gesture.translation.height
//                            
//                            withAnimation {
//                                // 当拖动当前图片到屏幕高度的一半时
//                                if abs(deltaY) > screenHeight/2 {
//                                    // 将当前图片从屏幕的上方或下方移出
//                                    currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                    // 当前图片移出屏幕后，下一张图片完全显示
//                                    nextOpacity = 1
//                                    // 当前图片移除屏幕后，下一张图片执行缩放动画后显示出来
//                                    nextScale = 1
//                                    
//                                    // 将下一张图片变成当前图片
//                                    self.currentIndex = nextIndex
//                                } else {
//                                    // 还原当前图片的默认偏移量
//                                    currentOffsetY = 0
//                                    // 还原下一张图片的默认透明度
//                                    nextOpacity = 0
//                                }
//                            }
//                        })
//                )
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}

//import SwiftUI
// /// - 实现了图片的上下滑动切换效果，但是切换的时候下一张图片有抖动问题
//struct SwiftUIView: View {
//    @State var currentIndex: Int = 0
//    @State var currentOffsetY: CGFloat = 0
//    @State var nextIndex: Int = 1
//    @State var nextOpacity: Double = 0
//    @State var nextScale: CGFloat = 0.8
//    
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            Image(movies[nextIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .opacity(nextOpacity)
//                .scaleEffect(nextScale)
//            
//            Image(movies[currentIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .offset(x: 0, y: currentOffsetY)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            currentOffsetY = gesture.translation.height
//                            nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
//                            nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
//                        }
//                        .onEnded { gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            let deltaY = gesture.translation.height
//                            
//                            withAnimation {
//                                if abs(deltaY) > screenHeight / 2 {
//                                    currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                    nextOpacity = 1
//                                    nextScale = 1
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                        currentIndex = nextIndex
//                                        currentOffsetY = 0
//                                        nextOpacity = 0
//                                        nextScale = 0.8
//                                        
//                                        if currentIndex + 1 < movies.count {
//                                            nextIndex = currentIndex + 1
//                                        } else {
//                                            nextIndex = 0
//                                        }
//                                    }
//                                } else {
//                                    currentOffsetY = 0
//                                    nextOpacity = 0
//                                    nextScale = 0.8
//                                }
//                            }
//                        }
//                )
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}


//import SwiftUI
//
///// - 完美实现了图片的切换功能
//struct SwiftUIView: View {
//    @State var currentIndex: Int = 0
//    @State var currentOffsetY: CGFloat = 0
//    @State var nextIndex: Int = 1
//    @State var nextOpacity: Double = 0
//    @State var nextScale: CGFloat = 0.8
//    
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            Image(movies[nextIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .opacity(nextOpacity)
//                .scaleEffect(nextScale)
//            
//            Image(movies[currentIndex].thumb)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .offset(x: 0, y: currentOffsetY)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            currentOffsetY = gesture.translation.height
//                            nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
//                            nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
//                        }
//                        .onEnded { gesture in
//                            let screenHeight = UIScreen.main.bounds.height
//                            let deltaY = gesture.translation.height
//                            
//                            if abs(deltaY) > screenHeight / 2 {
//                                withAnimation(.easeInOut(duration: 0.3)) {
//                                    currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                    nextOpacity = 1
//                                    nextScale = 1
//                                }
//                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                    currentIndex = nextIndex
//                                    currentOffsetY = 0
//                                    nextOpacity = 0
//                                    nextScale = 0.8
//                                    
//                                    if currentIndex + 1 < movies.count {
//                                        nextIndex = currentIndex + 1
//                                    } else {
//                                        nextIndex = 0
//                                    }
//                                }
//                            } else {
//                                withAnimation(.easeInOut(duration: 0.3)) {
//                                    currentOffsetY = 0
//                                    nextOpacity = 0
//                                    nextScale = 0.8
//                                }
//                            }
//                        }
//                )
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}


//import SwiftUI
///// - 实现了拖动图片移除图片的功能，但是最后一张图片会重复显示。
//struct SwiftUIView: View {
//    @State var currentIndex: Int = 0
//    @State var currentOffsetY: CGFloat = 0
//    @State var nextIndex: Int = 1
//    @State var nextOpacity: Double = 0
//    @State var nextScale: CGFloat = 0.8
//    
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    @State var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            if !movies.isEmpty {
//                Image(movies[nextIndex].thumb)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .opacity(nextOpacity)
//                    .scaleEffect(nextScale)
//                
//                Image(movies[currentIndex].thumb)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x: 0, y: currentOffsetY)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { gesture in
//                                let screenHeight = UIScreen.main.bounds.height
//                                currentOffsetY = gesture.translation.height
//                                nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
//                                nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
//                            }
//                            .onEnded { gesture in
//                                let screenHeight = UIScreen.main.bounds.height
//                                let deltaY = gesture.translation.height
//                                
//                                if abs(deltaY) > screenHeight / 2 {
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                        nextOpacity = 1
//                                        nextScale = 1
//                                    }
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                        // 移除当前图片
//                                        movies.remove(at: currentIndex)
//                                        
//                                        if movies.isEmpty {
//                                            currentOffsetY = 0
//                                            nextOpacity = 0
//                                            nextScale = 0.8
//                                        } else {
//                                            // 更新索引
//                                            currentIndex = currentIndex % movies.count
//                                            currentOffsetY = 0
//                                            nextOpacity = 0
//                                            nextScale = 0.8
//                                            
//                                            if currentIndex + 1 < movies.count {
//                                                nextIndex = currentIndex + 1
//                                            } else {
//                                                nextIndex = 0
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentOffsetY = 0
//                                        nextOpacity = 0
//                                        nextScale = 0.8
//                                    }
//                                }
//                            }
//                    )
//            } else {
//                Text("没有更多图片")
//                    .font(.largeTitle)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}


//import SwiftUI
//
//struct SwiftUIView: View {
//    @State var currentIndex: Int = 0
//    @State var currentOffsetY: CGFloat = 0
//    @State var nextIndex: Int = 1
//    @State var nextOpacity: Double = 0
//    @State var nextScale: CGFloat = 0.8
//    
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    @State var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            if !movies.isEmpty {
//                if currentIndex < movies.count {
//                    Image(movies[currentIndex].thumb)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .offset(x: 0, y: currentOffsetY)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { gesture in
//                                    let screenHeight = UIScreen.main.bounds.height
//                                    currentOffsetY = gesture.translation.height
//                                    
//                                    if currentIndex + 1 < movies.count {
//                                        nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
//                                        nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
//                                    }
//                                }
//                                .onEnded { gesture in
//                                    let screenHeight = UIScreen.main.bounds.height
//                                    let deltaY = gesture.translation.height
//                                    
//                                    if abs(deltaY) > screenHeight / 2 {
//                                        withAnimation(.easeInOut(duration: 0.3)) {
//                                            currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                            nextOpacity = 1
//                                            nextScale = 1
//                                        }
//                                        
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                            movies.remove(at: currentIndex)
//                                            
//                                            if movies.isEmpty {
//                                                currentOffsetY = 0
//                                                nextOpacity = 0
//                                                nextScale = 0.8
//                                            } else {
//                                                currentIndex = currentIndex % movies.count
//                                                currentOffsetY = 0
//                                                nextOpacity = 0
//                                                nextScale = 0.8
//                                                
//                                                if currentIndex + 1 < movies.count {
//                                                    nextIndex = currentIndex + 1
//                                                }
//                                            }
//                                        }
//                                    } else {
//                                        withAnimation(.easeInOut(duration: 0.3)) {
//                                            currentOffsetY = 0
//                                            nextOpacity = 0
//                                            nextScale = 0.8
//                                        }
//                                    }
//                                }
//                        )
//                }
//                
//                if currentIndex + 1 < movies.count {
//                    Image(movies[nextIndex].thumb)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(nextOpacity)
//                        .scaleEffect(nextScale)
//                }
//            } else {
//                Text("没有更多图片")
//                    .font(.largeTitle)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}


//import SwiftUI
//
///// 完美代码
//struct SwiftUIView: View {
//    @State var currentIndex: Int = 0
//    @State var currentOffsetY: CGFloat = 0
//    @State var nextIndex: Int = 1
//    @State var nextOpacity: Double = 0
//    @State var nextScale: CGFloat = 0.8
//    
//    struct Movie: Identifiable {
//        var id = UUID().uuidString
//        var thumb: String
//    }
//    
//    @State var movies: [Movie] = [
//        Movie(thumb: "m1"),
//        Movie(thumb: "m2"),
//        Movie(thumb: "m3"),
//        Movie(thumb: "m4"),
//        Movie(thumb: "m5"),
//        Movie(thumb: "m6"),
//        Movie(thumb: "m7"),
//        Movie(thumb: "m8"),
//    ]
//    
//    var body: some View {
//        ZStack {
//            if !movies.isEmpty {
//                // 下一张图片
//                if currentIndex + 1 < movies.count {
//                    Image(movies[nextIndex].thumb)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(nextOpacity)
//                        .scaleEffect(nextScale)
//                }
//
//                // 当前图片
//                Image(movies[currentIndex].thumb)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x: 0, y: currentOffsetY)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { gesture in
//                                let screenHeight = UIScreen.main.bounds.height
//                                currentOffsetY = gesture.translation.height
//                                
//                                if currentIndex + 1 < movies.count {
//                                    nextOpacity = abs(currentOffsetY) / (screenHeight * 0.9)
//                                    nextScale = 0.8 + 0.2 * (abs(currentOffsetY) / (screenHeight * 0.9))
//                                }
//                            }
//                            .onEnded { gesture in
//                                let screenHeight = UIScreen.main.bounds.height
//                                let deltaY = gesture.translation.height
//                                
//                                if abs(deltaY) > screenHeight / 2 {
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentOffsetY = deltaY > 0 ? screenHeight : -screenHeight
//                                        nextOpacity = 1
//                                        nextScale = 1
//                                    }
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                        movies.remove(at: currentIndex)
//                                        
//                                        if movies.isEmpty {
//                                            currentOffsetY = 0
//                                            nextOpacity = 0
//                                            nextScale = 0.8
//                                        } else {
//                                            currentIndex = currentIndex % movies.count
//                                            currentOffsetY = 0
//                                            nextOpacity = 0
//                                            nextScale = 0.8
//                                            
//                                            if currentIndex + 1 < movies.count {
//                                                nextIndex = currentIndex + 1
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentOffsetY = 0
//                                        nextOpacity = 0
//                                        nextScale = 0.8
//                                    }
//                                }
//                            }
//                    )
//            } else {
//                Text("没有更多图片")
//                    .font(.largeTitle)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .preferredColorScheme(.dark)
//}

import SwiftUI

struct SwiftUIView: View {
    @State var currentIndex: Int = 0
    @State var currentOffsetY: CGFloat = 0
    @State var nextOpacity: Double = 0
    @State var nextScale: CGFloat = 0.8
    @State var showAlert: Bool = false
    @State var alertScale: CGFloat = 0
    @State var alertOpacity: Double = 0

    struct Movie: Identifiable {
        var id = UUID().uuidString
        var thumb: String
    }

    @State var movies: [Movie] = [
        Movie(thumb: "m1"),
        Movie(thumb: "m2"),
        Movie(thumb: "m3"),
        Movie(thumb: "m4"),
        Movie(thumb: "m5"),
        Movie(thumb: "m6"),
        Movie(thumb: "m7"),
        Movie(thumb: "m8"),
    ]

    var body: some View {
        ZStack {
            if !movies.isEmpty {
                // 下一张图片
                if currentIndex + 1 < movies.count {
                    let nextIndex = currentIndex + 1
                    Image(movies[nextIndex].thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(nextOpacity)
                        .scaleEffect(nextScale)
                }

                // 当前图片
                Image(movies[currentIndex].thumb)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 0, y: currentOffsetY)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let screenHeight = UIScreen.main.bounds.height
                                currentOffsetY = gesture.translation.height

                                if currentIndex + 1 < movies.count {
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
                                        movies.remove(at: currentIndex)

                                        if movies.isEmpty {
                                            currentOffsetY = 0
                                            nextOpacity = 0
                                            nextScale = 0.8
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showAlert = true
                                                alertScale = 0
                                                alertOpacity = 0
                                            }
                                        } else {
                                            currentIndex = currentIndex % movies.count
                                            currentOffsetY = 0
                                            nextOpacity = 0
                                            nextScale = 0.8

//                                            if currentIndex + 1 < movies.count {
//                                                nextIndex = currentIndex + 1
//                                            }
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
                    )
            } 
            else {
                if showAlert {
                    Text("没有更多图片")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .opacity(alertOpacity)
                        .scaleEffect(alertScale)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                alertScale = 1
                                alertOpacity = 1
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    SwiftUIView()
        .preferredColorScheme(.dark)
}

