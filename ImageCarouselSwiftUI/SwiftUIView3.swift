//
//  SwiftUIView3.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4","m5", "m6", "m7", "m8"]
//    
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 1
//    @State private var currentOffset: CGSize = .zero
//    
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//    
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//    
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//    
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//    
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//            
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                PreCard(name: photos[currentIndex-1])
//                    .offset(leftPrevOffset)
//                
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirecton != .DH {
//                        NextCard(name: photos[currentIndex+1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                    }
//                    
//                    // 当前图片（显示在屏幕上）
//                    CurrentCard(name: photos[currentIndex])
//                        .offset(currentOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                        bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                        bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
//                                    }
//                                })
//                                .onEnded({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        // 拖动距离大于屏幕高度的一半时
//                                        if abs(deltaY) > screenHeight/2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                bgNextOpacity = 1
//                                                bgNextScale = 1
//                                            }
//                                            
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                photos.remove(at: currentIndex)
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕高度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = .zero
//                                            }
//                                        }
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        // 拖动距离大于屏幕宽度的一半时
//                                        if abs(deltaX) > screenWidth/2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                if deltaX > 0 {
//                                                    // TODO: 向右拖动
//                                                    
//                                                } else {
//                                                    // TODO: 向左拖动
//                                                    
//                                                }
//                                            }
//                                        } else {
//                                            // TODO: 拖动距离不足屏幕宽度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = .zero
//                                            }
//                                        }
//                                    }
//                                    
//                                    // 拖动结束后，设置拖动方向为无方向
//                                    currentDirecton = .DN
//                                })
//                        )
//                }
//                
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                NextCard(name: photos[currentIndex+1])
//                    .offset(rightNextOffset)
//            }
//        }
//    }
//    
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//    
//    struct Card: View {
//        let name: String
//        
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}
//
///// - 运行该代码，手机屏幕上出现2张图片，各占屏幕宽度的一半，左右拖动图片时，图片也没有实现切换功能。
///// 这不是我想实现的效果。我希望图片的宽度占满屏幕的宽度，
///// 并且当往左拖动图片时，切换显示屏幕右侧的下一张图片，当往右拖动图片时，
///// 切换显示屏幕左侧的上一张图片。请继续完善代码实现这些功能。
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]
//    
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//    
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//    
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//    
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//    
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//    
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//            
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                if currentIndex > 0 {
//                    PreCard(name: photos[currentIndex - 1])
//                        .offset(leftPrevOffset)
//                }
//                
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirecton != .DH && currentIndex + 1 < photos.count {
//                        NextCard(name: photos[currentIndex + 1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                            .offset(bgNextOffset)
//                    }
//                    
//                    // 当前图片（显示在屏幕上）
//                    CurrentCard(name: photos[currentIndex])
//                        .offset(currentOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                        bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                        bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
//                                        leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                        rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                    }
//                                })
//                                .onEnded({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        // 拖动距离大于屏幕高度的一半时
//                                        if abs(deltaY) > screenHeight / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                bgNextOpacity = 1
//                                                bgNextScale = 1
//                                            }
//                                            
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                photos.remove(at: currentIndex)
//                                                if currentIndex >= photos.count {
//                                                    currentIndex = max(0, photos.count - 1)
//                                                }
//                                                resetOffsets()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕高度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetOffsets()
//                                            }
//                                        }
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        // 拖动距离大于屏幕宽度的一半时
//                                        if abs(deltaX) > screenWidth / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                if deltaX > 0 {
//                                                    // 向右拖动
//                                                    if currentIndex > 0 {
//                                                        currentIndex -= 1
//                                                    }
//                                                } else {
//                                                    // 向左拖动
//                                                    if currentIndex + 1 < photos.count {
//                                                        currentIndex += 1
//                                                    }
//                                                }
//                                                resetOffsets()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕宽度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetOffsets()
//                                            }
//                                        }
//                                    }
//                                    
//                                    // 拖动结束后，设置拖动方向为无方向
//                                    currentDirecton = .DN
//                                })
//                        )
//                }
//                
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                if currentIndex + 1 < photos.count {
//                    NextCard(name: photos[currentIndex + 1])
//                        .offset(rightNextOffset)
//                }
//            }
//        }
//    }
//    
//    private func resetOffsets() {
//        currentOffset = .zero
//        leftPrevOffset = .zero
//        rightNextOffset = .zero
//        bgNextOpacity = 0
//        bgNextScale = 0.8
//        bgNextOffset = .zero
//    }
//    
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//    
//    struct Card: View {
//        let name: String
//        
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

///// - 但是还需要完善一下代码：当向右拖动图片时，上一张图片要跟随当前图片同步向右移动；
///// 当向左拖动图片时，下一张图片也要跟随当前图片同步向左移动。
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]
//    
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//    
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//    
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//            
//            // 当前图片（显示在屏幕上）
//            if !photos.isEmpty {
//                ZStack {
//                    // 背后的下一张图片
//                    if currentIndex + 1 < photos.count {
//                        Image(photos[currentIndex + 1])
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: screenWidth)
//                            .scaleEffect(0.8)
//                            .opacity(0.8)
//                    }
//                    
//                    // 当前图片
//                    Image(photos[currentIndex])
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: screenWidth)
//                        .offset(currentOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
//                                    }
//                                })
//                                .onEnded({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//                                    
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//                                    
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        // 拖动距离大于屏幕高度的一半时
//                                        if abs(deltaY) > screenHeight / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                            }
//                                            
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                photos.remove(at: currentIndex)
//                                                if currentIndex >= photos.count {
//                                                    currentIndex = max(0, photos.count - 1)
//                                                }
//                                                resetOffsets()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕高度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetOffsets()
//                                            }
//                                        }
//                                        
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        // 拖动距离大于屏幕宽度的一半时
//                                        if abs(deltaX) > screenWidth / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                if deltaX > 0 {
//                                                    // 向右拖动
//                                                    if currentIndex > 0 {
//                                                        currentIndex -= 1
//                                                    }
//                                                } else {
//                                                    // 向左拖动
//                                                    if currentIndex + 1 < photos.count {
//                                                        currentIndex += 1
//                                                    }
//                                                }
//                                                resetOffsets()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕宽度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetOffsets()
//                                            }
//                                        }
//                                    }
//                                    
//                                    // 拖动结束后，设置拖动方向为无方向
//                                    currentDirecton = .DN
//                                })
//                        )
//                }
//            }
//        }
//    }
//    
//    private func resetOffsets() {
//        currentOffset = .zero
//    }
//    
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}


///// - 运行该代码，当向右滑动当前图片时，下面这一行代码出现了数组越界：
///// - PreCard(name: photos[currentIndex-1])
///// - 在垂直方向滑动到最后一张图片时，下面这一行代码也出现了数组越界：
///// - NextCard(name: photos[currentIndex+1])
///// - 请修复这两个问题。
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4","m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 1
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                PreCard(name: photos[currentIndex-1])
//                    .offset(x: leftPrevOffset.width, y: 0)
//
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirecton != .DH {
//                        NextCard(name: photos[currentIndex+1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                    }
//
//                    // 当前图片（显示在屏幕上）
//                    CurrentCard(name: photos[currentIndex])
//                        .offset(currentOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                        bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                        bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                        // 同步更新上一张图片和下一张图片的offset
//                                        if gesture.translation.width > 0 {
//                                            leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                        } else {
//                                            rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                        }
//                                    }
//                                })
//                                .onEnded({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        // 拖动距离大于屏幕高度的一半时
//                                        if abs(deltaY) > screenHeight / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                bgNextOpacity = 1
//                                                bgNextScale = 1
//                                            }
//
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                photos.remove(at: currentIndex)
//                                                resetUI()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕高度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetUI()
//                                            }
//                                        }
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        // 拖动距离大于屏幕宽度的一半时
//                                        if abs(deltaX) > screenWidth / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                if deltaX > 0 {
//                                                    // 向右拖动
//                                                    currentIndex = max(0, currentIndex - 1)
//                                                } else {
//                                                    // 向左拖动
//                                                    currentIndex = min(photos.count - 1, currentIndex + 1)
//                                                }
//                                                resetUI()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕宽度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetUI()
//                                            }
//                                        }
//                                    }
//
//                                    // 拖动结束后，设置拖动方向为无方向
//                                    currentDirecton = .DN
//                                })
//                        )
//                }
//
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                NextCard(name: photos[currentIndex+1])
//                    .offset(x: rightNextOffset.width, y: 0)
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}


/**
 运行该代码，出现2个问题。
 问题1:屏幕上首先显示的不是图片数组的第1张图片，而是显示了第2张图片。
 问题2:在垂直拖动图片到最后一张图片时，屏幕上显示了2张图片，屏幕的左边部分显示的是第1张图片，屏幕的右半部分显示的是最后一张图片。当向上拖动屏幕上显示的最后一张图片时，这行代码出现了数组越界：CurrentCard(name: photos[currentIndex])
 请继续修复这2个问题。
 */
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4","m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 1
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                if currentIndex > 0 {
//                    PreCard(name: photos[currentIndex-1])
//                        .offset(x: leftPrevOffset.width, y: 0)
//                }
//
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirecton != .DH && currentIndex < photos.count - 1 {
//                        NextCard(name: photos[currentIndex+1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                    }
//
//                    // 当前图片（显示在屏幕上）
//                    CurrentCard(name: photos[currentIndex])
//                        .offset(currentOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                        bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                        bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                        // 同步更新上一张图片和下一张图片的offset
//                                        if gesture.translation.width > 0 && currentIndex > 0 {
//                                            leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                        } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
//                                            rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                        }
//                                    }
//                                })
//                                .onEnded({ gesture in
//                                    // 获取拖动的偏移量
//                                    let deltaX = gesture.translation.width
//                                    let deltaY = gesture.translation.height
//
//                                    // 计算拖动方向
//                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                    if currentDirecton == .DV {
//                                        // 垂直拖动
//                                        // 拖动距离大于屏幕高度的一半时
//                                        if abs(deltaY) > screenHeight / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                bgNextOpacity = 1
//                                                bgNextScale = 1
//                                            }
//
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                photos.remove(at: currentIndex)
//                                                resetUI()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕高度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetUI()
//                                            }
//                                        }
//                                    } else if currentDirecton == .DH {
//                                        // 水平拖动
//                                        // 拖动距离大于屏幕宽度的一半时
//                                        if abs(deltaX) > screenWidth / 2 {
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                if deltaX > 0 && currentIndex > 0 {
//                                                    // 向右拖动
//                                                    currentIndex -= 1
//                                                } else if deltaX < 0 && currentIndex < photos.count - 1 {
//                                                    // 向左拖动
//                                                    currentIndex += 1
//                                                }
//                                                resetUI()
//                                            }
//                                        } else {
//                                            // 拖动距离不足屏幕宽度的一半时
//                                            withAnimation(.easeInOut(duration: 0.3)) {
//                                                resetUI()
//                                            }
//                                        }
//                                    }
//
//                                    // 拖动结束后，设置拖动方向为无方向
//                                    currentDirecton = .DN
//                                })
//                        )
//                }
//
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                if currentIndex < photos.count - 1 {
//                    NextCard(name: photos[currentIndex+1])
//                        .offset(x: rightNextOffset.width, y: 0)
//                }
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

/**
 运行该代码，出现了2个问题。
 第1个问题：运行代码后，手机屏幕出现左右两张图片，左边的图片可以上下拖动，右侧显示的应该是下一张图片。当前图片应该占满整个屏幕的宽度。
 第2个问题：上下拖动移除图片到最后一张时，这行代码出现数组越界：CurrentCard(name: photos[currentIndex])
 */
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4","m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirecton: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                if currentIndex > 0 {
//                    PreCard(name: photos[currentIndex-1])
//                        .offset(x: leftPrevOffset.width, y: 0)
//                }
//
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirecton != .DH && currentIndex < photos.count - 1 {
//                        NextCard(name: photos[currentIndex+1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                    }
//
//                    // 当前图片（显示在屏幕上）
//                    if currentIndex < photos.count {
//                        CurrentCard(name: photos[currentIndex])
//                            .offset(currentOffset)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged({ gesture in
//                                        // 获取拖动的偏移量
//                                        let deltaX = gesture.translation.width
//                                        let deltaY = gesture.translation.height
//
//                                        // 计算拖动方向
//                                        currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                        if currentDirecton == .DV {
//                                            // 垂直拖动
//                                            currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                            bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                            bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                        } else if currentDirecton == .DH {
//                                            // 水平拖动
//                                            currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                            // 同步更新上一张图片和下一张图片的offset
//                                            if gesture.translation.width > 0 && currentIndex > 0 {
//                                                leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                            } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
//                                                rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                            }
//                                        }
//                                    })
//                                    .onEnded({ gesture in
//                                        // 获取拖动的偏移量
//                                        let deltaX = gesture.translation.width
//                                        let deltaY = gesture.translation.height
//
//                                        // 计算拖动方向
//                                        currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                        if currentDirecton == .DV {
//                                            // 垂直拖动
//                                            // 拖动距离大于屏幕高度的一半时
//                                            if abs(deltaY) > screenHeight / 2 {
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                    bgNextOpacity = 1
//                                                    bgNextScale = 1
//                                                }
//
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                    photos.remove(at: currentIndex)
//                                                    if currentIndex >= photos.count {
//                                                        currentIndex = photos.count - 1
//                                                    }
//                                                    resetUI()
//                                                }
//                                            } else {
//                                                // 拖动距离不足屏幕高度的一半时
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    resetUI()
//                                                }
//                                            }
//                                        } else if currentDirecton == .DH {
//                                            // 水平拖动
//                                            // 拖动距离大于屏幕宽度的一半时
//                                            if abs(deltaX) > screenWidth / 2 {
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    if deltaX > 0 && currentIndex > 0 {
//                                                        // 向右拖动
//                                                        currentIndex -= 1
//                                                    } else if deltaX < 0 && currentIndex < photos.count - 1 {
//                                                        // 向左拖动
//                                                        currentIndex += 1
//                                                    }
//                                                    resetUI()
//                                                }
//                                            } else {
//                                                // 拖动距离不足屏幕宽度的一半时
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    resetUI()
//                                                }
//                                            }
//                                        }
//
//                                        // 拖动结束后，设置拖动方向为无方向
//                                        currentDirecton = .DN
//                                    })
//                            )
//                    }
//                }
//
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                if currentIndex < photos.count - 1 {
//                    NextCard(name: photos[currentIndex+1])
//                        .offset(x: rightNextOffset.width, y: 0)
//                }
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

///// 实现了图片的水平和垂直方向的拖动，但是移除最后一张图片是出现数组越界，但问题不大，整体功能还好。
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirection: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            HStack(spacing: 0) {
//                // 上一张图片,位于当前图片的左边（屏幕外）
//                if currentIndex > 0 {
//                    PreCard(name: photos[currentIndex - 1])
//                        .offset(x: leftPrevOffset.width)
//                        .frame(width: screenWidth)
//                } else {
//                    // 空白视图，占位用
//                    Spacer().frame(width: screenWidth)
//                }
//
//                ZStack {
//                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                    if currentDirection != .DH && currentIndex < photos.count - 1 {
//                        NextCard(name: photos[currentIndex + 1])
//                            .scaleEffect(bgNextScale)
//                            .opacity(bgNextOpacity)
//                            .frame(width: screenWidth)
//                    }
//
//                    // 当前图片（显示在屏幕上）
//                    if currentIndex < photos.count {
//                        CurrentCard(name: photos[currentIndex])
//                            .offset(currentOffset)
//                            .frame(width: screenWidth)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged({ gesture in
//                                        // 获取拖动的偏移量
//                                        let deltaX = gesture.translation.width
//                                        let deltaY = gesture.translation.height
//
//                                        // 计算拖动方向
//                                        currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                        if currentDirection == .DV {
//                                            // 垂直拖动
//                                            currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                            bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                            bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                        } else if currentDirection == .DH {
//                                            // 水平拖动
//                                            currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                            // 同步更新上一张图片和下一张图片的offset
//                                            if gesture.translation.width > 0 && currentIndex > 0 {
//                                                leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                            } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
//                                                rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                            }
//                                        }
//                                    })
//                                    .onEnded({ gesture in
//                                        // 获取拖动的偏移量
//                                        let deltaX = gesture.translation.width
//                                        let deltaY = gesture.translation.height
//
//                                        // 计算拖动方向
//                                        currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                        if currentDirection == .DV {
//                                            // 垂直拖动
//                                            // 拖动距离大于屏幕高度的一半时
//                                            if abs(deltaY) > screenHeight / 2 {
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                    bgNextOpacity = 1
//                                                    bgNextScale = 1
//                                                }
//
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                    photos.remove(at: currentIndex)
//                                                    if currentIndex >= photos.count {
//                                                        currentIndex = photos.count - 1
//                                                    }
//                                                    resetUI()
//                                                }
//                                            } else {
//                                                // 拖动距离不足屏幕高度的一半时
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    resetUI()
//                                                }
//                                            }
//                                        } else if currentDirection == .DH {
//                                            // 水平拖动
//                                            // 拖动距离大于屏幕宽度的一半时
//                                            if abs(deltaX) > screenWidth / 2 {
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    if deltaX > 0 && currentIndex > 0 {
//                                                        // 向右拖动
//                                                        currentIndex -= 1
//                                                    } else if deltaX < 0 && currentIndex < photos.count - 1 {
//                                                        // 向左拖动
//                                                        currentIndex += 1
//                                                    }
//                                                    resetUI()
//                                                }
//                                            } else {
//                                                // 拖动距离不足屏幕宽度的一半时
//                                                withAnimation(.easeInOut(duration: 0.3)) {
//                                                    resetUI()
//                                                }
//                                            }
//                                        }
//
//                                        // 拖动结束后，设置拖动方向为无方向
//                                        currentDirection = .DN
//                                    })
//                            )
//                    }
//                }
//
//                // 下一张图片，位于当前图片的右侧（屏幕外）
//                if currentIndex < photos.count - 1 {
//                    NextCard(name: photos[currentIndex + 1])
//                        .offset(x: rightNextOffset.width)
//                        .frame(width: screenWidth)
//                } else {
//                    // 空白视图，占位用
//                    Spacer().frame(width: screenWidth)
//                }
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

//
///**
// 该版本的代码完美实现了水平拖动切换浏览图片和垂直拖动移除图片并切换图片的功能。但是美中不足的是当水平拖动当前图片时，下一张图片或上一张图片没有跟随当前图片同步进行水平位移。
// 在此代码基础上增加一个功能：当移除最后一场图片之后，屏幕上显示提示文字：没有更多图片。
// */
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirection: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            if photos.isEmpty {
//                Text("没有更多图片")
//                    .font(.largeTitle)
//                    .foregroundColor(.gray)
//            } else {
//                HStack(spacing: 0) {
//                    // 上一张图片,位于当前图片的左边（屏幕外）
//                    if currentIndex > 0 {
//                        PreCard(name: photos[currentIndex - 1])
//                            .offset(x: leftPrevOffset.width)
//                            .frame(width: screenWidth)
//                    } else {
//                        // 空白视图，占位用
//                        Spacer().frame(width: screenWidth)
//                    }
//
//                    ZStack {
//                        // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                        if currentDirection != .DH && currentIndex < photos.count - 1 {
//                            NextCard(name: photos[currentIndex + 1])
//                                .scaleEffect(bgNextScale)
//                                .opacity(bgNextOpacity)
//                                .frame(width: screenWidth)
//                        }
//
//                        // 当前图片（显示在屏幕上）
//                        if currentIndex < photos.count {
//                            CurrentCard(name: photos[currentIndex])
//                                .offset(currentOffset)
//                                .frame(width: screenWidth)
//                                .gesture(
//                                    DragGesture()
//                                        .onChanged({ gesture in
//                                            // 获取拖动的偏移量
//                                            let deltaX = gesture.translation.width
//                                            let deltaY = gesture.translation.height
//
//                                            // 计算拖动方向
//                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                            if currentDirection == .DV {
//                                                // 垂直拖动
//                                                currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                                bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                                bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                            } else if currentDirection == .DH {
//                                                // 水平拖动
//                                                currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                                // 同步更新上一张图片和下一张图片的offset
//                                                if gesture.translation.width > 0 && currentIndex > 0 {
//                                                    leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                                } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
//                                                    rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                                }
//                                            }
//                                        })
//                                        .onEnded({ gesture in
//                                            // 获取拖动的偏移量
//                                            let deltaX = gesture.translation.width
//                                            let deltaY = gesture.translation.height
//
//                                            // 计算拖动方向
//                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                            if currentDirection == .DV {
//                                                // 垂直拖动
//                                                // 拖动距离大于屏幕高度的一半时
//                                                if abs(deltaY) > screenHeight / 2 {
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                        bgNextOpacity = 1
//                                                        bgNextScale = 1
//                                                    }
//
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                        photos.remove(at: currentIndex)
//                                                        if currentIndex >= photos.count {
//                                                            currentIndex = photos.count - 1
//                                                        }
//                                                        resetUI()
//                                                    }
//                                                } else {
//                                                    // 拖动距离不足屏幕高度的一半时
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        resetUI()
//                                                    }
//                                                }
//                                            } else if currentDirection == .DH {
//                                                // 水平拖动
//                                                // 拖动距离大于屏幕宽度的一半时
//                                                if abs(deltaX) > screenWidth / 2 {
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        if deltaX > 0 && currentIndex > 0 {
//                                                            // 向右拖动
//                                                            currentIndex -= 1
//                                                        } else if deltaX < 0 && currentIndex < photos.count - 1 {
//                                                            // 向左拖动
//                                                            currentIndex += 1
//                                                        }
//                                                        resetUI()
//                                                    }
//                                                } else {
//                                                    // 拖动距离不足屏幕宽度的一半时
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        resetUI()
//                                                    }
//                                                }
//                                            }
//
//                                            // 拖动结束后，设置拖动方向为无方向
//                                            currentDirection = .DN
//                                        })
//                                )
//                        }
//                    }
//
//                    // 下一张图片，位于当前图片的右侧（屏幕外）
//                    if currentIndex < photos.count - 1 {
//                        NextCard(name: photos[currentIndex + 1])
//                            .offset(x: rightNextOffset.width)
//                            .frame(width: screenWidth)
//                    } else {
//                        // 空白视图，占位用
//                        Spacer().frame(width: screenWidth)
//                    }
//                }
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

///**
// 当向左水平拖动当前图片离开屏幕之后，下一张图片会从屏幕左侧向右滑入屏幕；当向右水平拖动当前图片离开屏幕后，上一张图片会从屏幕右侧向左滑入屏幕。这是什么原因导致的？
// */
//import SwiftUI
//
//struct SwiftUIView3: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//
//    // 图片数组
//    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]
//
//    // 当前图片的状态属性
//    @State private var currentIndex: Int = 0
//    @State private var currentOffset: CGSize = .zero
//
//    // 当前图片的拖动方向
//    @State private var currentDirection: Direction = .DN
//
//    // 当前图片背后的下一张图片的状态属性
//    @State private var bgNextOffset: CGSize = .zero
//    @State private var bgNextScale: CGFloat = 0.8
//    @State private var bgNextOpacity: Double = 0
//
//    // 当前图片右侧下一张图片的状态属性
//    @State private var rightNextOffset: CGSize = .zero
//
//    // 当前图片左侧上一张图片的状态属性
//    @State private var leftPrevOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            Color.brown.opacity(0.2).ignoresSafeArea()
//
//            if photos.isEmpty {
//                Text("没有更多图片")
//                    .font(.largeTitle)
//                    .foregroundColor(.gray)
//            } else {
//                HStack(spacing: 0) {
//                    // 上一张图片,位于当前图片的左边（屏幕外）
//                    if currentIndex > 0 {
//                        PreCard(name: photos[currentIndex - 1])
//                            .offset(x: leftPrevOffset.width)
//                            .frame(width: screenWidth)
//                    } else {
//                        // 空白视图，占位用
//                        Spacer().frame(width: screenWidth)
//                    }
//
//                    ZStack {
//                        // 下一张图片（位于当前图片的背后，被当前图片遮挡）
//                        if currentDirection != .DH && currentIndex < photos.count - 1 {
//                            NextCard(name: photos[currentIndex + 1])
//                                .scaleEffect(bgNextScale)
//                                .opacity(bgNextOpacity)
//                                .frame(width: screenWidth)
//                        }
//
//                        // 当前图片（显示在屏幕上）
//                        if currentIndex < photos.count {
//                            CurrentCard(name: photos[currentIndex])
//                                .offset(currentOffset)
//                                .frame(width: screenWidth)
//                                .gesture(
//                                    DragGesture()
//                                        .onChanged({ gesture in
//                                            // 获取拖动的偏移量
//                                            let deltaX = gesture.translation.width
//                                            let deltaY = gesture.translation.height
//
//                                            // 计算拖动方向
//                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                            if currentDirection == .DV {
//                                                // 垂直拖动
//                                                currentOffset = CGSize(width: 0, height: gesture.translation.height)
//                                                bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
//                                                bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
//                                            } else if currentDirection == .DH {
//                                                // 水平拖动
//                                                currentOffset = CGSize(width: gesture.translation.width, height: 0)
//
//                                                // 同步更新上一张图片和下一张图片的offset
//                                                if gesture.translation.width > 0 && currentIndex > 0 {
//                                                    leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
//                                                } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
//                                                    rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
//                                                }
//                                            }
//                                        })
//                                        .onEnded({ gesture in
//                                            // 获取拖动的偏移量
//                                            let deltaX = gesture.translation.width
//                                            let deltaY = gesture.translation.height
//
//                                            // 计算拖动方向
//                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV
//
//                                            if currentDirection == .DV {
//                                                // 垂直拖动
//                                                // 拖动距离大于屏幕高度的一半时
//                                                if abs(deltaY) > screenHeight / 2 {
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
//                                                        bgNextOpacity = 1
//                                                        bgNextScale = 1
//                                                    }
//
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                        photos.remove(at: currentIndex)
//                                                        if currentIndex >= photos.count {
//                                                            currentIndex = photos.count - 1
//                                                        }
//                                                        resetUI()
//                                                    }
//                                                } else {
//                                                    // 拖动距离不足屏幕高度的一半时
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        resetUI()
//                                                    }
//                                                }
//                                            } else if currentDirection == .DH {
//                                                // 水平拖动
//                                                // 拖动距离大于屏幕宽度的一半时
//                                                if abs(deltaX) > screenWidth / 2 {
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        if deltaX > 0 && currentIndex > 0 {
//                                                            // 向右拖动
//                                                            currentIndex -= 1
//                                                        } else if deltaX < 0 && currentIndex < photos.count - 1 {
//                                                            // 向左拖动
//                                                            currentIndex += 1
//                                                        }
//                                                        resetUI()
//                                                    }
//                                                } else {
//                                                    // 拖动距离不足屏幕宽度的一半时
//                                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                                        resetUI()
//                                                    }
//                                                }
//                                            }
//
//                                            // 拖动结束后，设置拖动方向为无方向
//                                            currentDirection = .DN
//                                        })
//                                )
//                        }
//                    }
//
//                    // 下一张图片，位于当前图片的右侧（屏幕外）
//                    if currentIndex < photos.count - 1 {
//                        NextCard(name: photos[currentIndex + 1])
//                            .offset(x: rightNextOffset.width)
//                            .frame(width: screenWidth)
//                    } else {
//                        // 空白视图，占位用
//                        Spacer().frame(width: screenWidth)
//                    }
//                }
//            }
//        }
//    }
//
//    enum Direction: String {
//        case DV = "垂直"
//        case DH = "水平"
//        case DN = "无方向"
//    }
//
//    struct Card: View {
//        let name: String
//
//        var body: some View {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
//        }
//    }
//
//    struct CurrentCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct PreCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    struct NextCard: View {
//        let name: String
//        var body: some View {
//            Card(name: name)
//        }
//    }
//
//    private func resetUI() {
//        currentOffset = .zero
//        bgNextOffset = .zero
//        bgNextScale = 0.8
//        bgNextOpacity = 0
//        rightNextOffset = .zero
//        leftPrevOffset = .zero
//    }
//}
//
//#Preview {
//    SwiftUIView3()
//        .preferredColorScheme(.dark)
//}

import SwiftUI

struct SwiftUIView3: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    // 图片数组
    @State private var photos: [String] = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"]

    // 当前图片的状态属性
    @State private var currentIndex: Int = 0
    @State private var currentOffset: CGSize = .zero

    // 当前图片的拖动方向
    @State private var currentDirection: Direction = .DN

    // 当前图片背后的下一张图片的状态属性
    @State private var bgNextOffset: CGSize = .zero
    @State private var bgNextScale: CGFloat = 0.8
    @State private var bgNextOpacity: Double = 0

    // 当前图片右侧下一张图片的状态属性
    @State private var rightNextOffset: CGSize = .zero

    // 当前图片左侧上一张图片的状态属性
    @State private var leftPrevOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.brown.opacity(0.2).ignoresSafeArea()

            if photos.isEmpty {
                Text("没有更多图片")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            } else {
                HStack(spacing: 0) {
                    // 上一张图片,位于当前图片的左边（屏幕外）
                    if currentIndex > 0 {
                        PreCard(name: photos[currentIndex - 1])
                            .offset(x: leftPrevOffset.width)
                            .frame(width: screenWidth)
                    } else {
                        // 空白视图，占位用
                        Spacer().frame(width: screenWidth)
                    }

                    ZStack {
                        // 下一张图片（位于当前图片的背后，被当前图片遮挡）
                        if currentDirection != .DH && currentIndex < photos.count - 1 {
                            NextCard(name: photos[currentIndex + 1])
                                .scaleEffect(bgNextScale)
                                .opacity(bgNextOpacity)
                                .frame(width: screenWidth)
                        }

                        // 当前图片（显示在屏幕上）
                        if currentIndex < photos.count {
                            CurrentCard(name: photos[currentIndex])
                                .offset(currentOffset)
                                .frame(width: screenWidth)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ gesture in
                                            // 获取拖动的偏移量
                                            let deltaX = gesture.translation.width
                                            let deltaY = gesture.translation.height

                                            // 计算拖动方向
                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV

                                            if currentDirection == .DV {
                                                // 垂直拖动
                                                currentOffset = CGSize(width: 0, height: gesture.translation.height)
                                                bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
                                                bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
                                            } else if currentDirection == .DH {
                                                // 水平拖动
                                                currentOffset = CGSize(width: gesture.translation.width, height: 0)

                                                // 同步更新上一张图片和下一张图片的offset
                                                if gesture.translation.width > 0 && currentIndex > 0 {
                                                    //leftPrevOffset = CGSize(width: gesture.translation.width - screenWidth, height: 0)
                                                    leftPrevOffset = CGSize(width: gesture.translation.width, height: 0)
                                                } else if gesture.translation.width < 0 && currentIndex < photos.count - 1 {
                                                    //rightNextOffset = CGSize(width: gesture.translation.width + screenWidth, height: 0)
                                                    rightNextOffset = CGSize(width: gesture.translation.width, height: 0)
                                                }
                                            }
                                        })
                                        .onEnded({ gesture in
                                            // 获取拖动的偏移量
                                            let deltaX = gesture.translation.width
                                            let deltaY = gesture.translation.height

                                            // 计算拖动方向
                                            currentDirection = abs(deltaX) > abs(deltaY) ? .DH : .DV

                                            if currentDirection == .DV {
                                                // 垂直拖动
                                                // 拖动距离大于屏幕高度的一半时
                                                if abs(deltaY) > screenHeight / 2 {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
                                                        bgNextOpacity = 1
                                                        bgNextScale = 1
                                                    }

                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        photos.remove(at: currentIndex)
                                                        if currentIndex >= photos.count {
                                                            currentIndex = photos.count - 1
                                                        }
                                                        resetUI()
                                                    }
                                                } else {
                                                    // 拖动距离不足屏幕高度的一半时
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        resetUI()
                                                    }
                                                }
                                            } else if currentDirection == .DH {
                                                // 水平拖动
                                                // 拖动距离大于屏幕宽度的一半时
                                                if abs(deltaX) > screenWidth / 2 {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        if deltaX > 0 && currentIndex > 0 {
                                                            // 向右拖动
                                                            currentIndex -= 1
                                                            currentOffset.width = screenWidth
                                                        } else if deltaX < 0 && currentIndex < photos.count - 1 {
                                                            // 向左拖动
                                                            currentIndex += 1
                                                            currentOffset.width = -screenWidth
                                                        }
                                                    }
                                                    resetUI()
                                                } else {
                                                    // 拖动距离不足屏幕宽度的一半时
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        resetUI()
                                                    }
                                                }
                                            }

                                            // 拖动结束后，设置拖动方向为无方向
                                            currentDirection = .DN
                                        })
                                )
                        }
                    }

                    // 下一张图片，位于当前图片的右侧（屏幕外）
                    if currentIndex < photos.count - 1 {
                        NextCard(name: photos[currentIndex + 1])
                            .offset(x: rightNextOffset.width)
                            .frame(width: screenWidth)
                    } else {
                        // 空白视图，占位用
                        Spacer().frame(width: screenWidth)
                    }
                }
            }
        }
    }

    enum Direction: String {
        case DV = "垂直"
        case DH = "水平"
        case DN = "无方向"
    }

    struct Card: View {
        let name: String

        var body: some View {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        }
    }

    struct CurrentCard: View {
        let name: String
        var body: some View {
            Card(name: name)
        }
    }

    struct PreCard: View {
        let name: String
        var body: some View {
            Card(name: name)
        }
    }

    struct NextCard: View {
        let name: String
        var body: some View {
            Card(name: name)
        }
    }

    private func resetUI() {
        currentOffset = .zero
        bgNextOffset = .zero
        bgNextScale = 0.8
        //bgNextOpacity = 0
        rightNextOffset = .zero
        leftPrevOffset = .zero
    }
}

#Preview {
    SwiftUIView3()
        .preferredColorScheme(.dark)
}
