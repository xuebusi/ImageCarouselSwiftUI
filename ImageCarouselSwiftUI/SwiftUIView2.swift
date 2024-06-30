//
//  SwiftUIView2.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

import SwiftUI

struct SwiftUIView2: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var photos: [String] = ["m1", "m2", "m3", "m4","m5", "m6", "m7", "m8"]
    @State private var hOffset: CGSize = .zero
    @State private var hImageCount: Int = 1
    
    // 当前图片的状态属性
    @State private var currentIndex: Int = 1
    @State private var currentOffset: CGSize = .zero
    
    // 当前图片的拖动方向
    @State private var currentDirecton: Direction = .DN
    
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
            
            HStack(spacing: 0) {
                // 上一张图片,位于当前图片的左边（屏幕外）
                PreCard(name: photos[currentIndex-1])
                    .offset(leftPrevOffset)
                
                ZStack {
                    // 下一张图片（位于当前图片的背后，被当前图片遮挡）
                    if currentDirecton != .DH {
                        NextCard(name: photos[currentIndex+1])
                            .scaleEffect(bgNextScale)
                            .opacity(bgNextOpacity)
                    }
                    
                    // 当前图片（显示在屏幕上）
                    CurrentCard(name: photos[currentIndex])
                        .offset(currentOffset)
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    // 获取拖动的偏移量
                                    let deltaX = gesture.translation.width
                                    let deltaY = gesture.translation.height
                                    
                                    // 计算拖动方向
                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
                                    
                                    if currentDirecton == .DV {
                                        // 垂直拖动
                                        currentOffset = CGSize(width: 0, height: gesture.translation.height)
                                        bgNextOpacity = abs(currentOffset.height) / (screenHeight * 0.9)
                                        bgNextScale = 0.8 + 0.2 * (abs(currentOffset.height) / (screenHeight * 0.9))
                                        
                                    } else if currentDirecton == .DH {
                                        // 水平拖动
                                        currentOffset = CGSize(width: gesture.translation.width, height: 0)
                                    }
                                    
                                    
                                })
                                .onEnded({ gesture in
                                    // 获取拖动的偏移量
                                    let deltaX = gesture.translation.width
                                    let deltaY = gesture.translation.height
                                    
                                    // 计算拖动方向
                                    currentDirecton = abs(deltaX) > abs(deltaY) ? .DH : .DV
                                    
                                    if currentDirecton == .DV {
                                        // 垂直拖动
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            // 拖动距离大于屏幕高度的一半时
                                            if abs(deltaY) > screenHeight/2 {
                                                currentOffset = CGSize(width: 0, height: deltaY > 0 ? screenHeight : -screenHeight)
                                                bgNextOpacity = 1
                                                bgNextScale = 1
                                            } else {
                                                // 拖动距离不足屏幕高度的一半时
                                                currentOffset = .zero
                                            }
                                        }
                                    } else if currentDirecton == .DH {
                                        // 水平拖动
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            // 拖动距离大于屏幕宽度的一半时
                                            if abs(deltaX) > screenWidth/2 {
                                                if deltaX > 0 {
                                                    // TODO: 向右拖动
                                                    
                                                } else {
                                                    // TODO: 向左拖动
                                                    
                                                }
                                            } else {
                                                // TODO: 拖动距离不足屏幕宽度的一半时
                                                
                                            }
                                        }
                                    }
                                    
                                    // 拖动结束后，设置拖动方向为无方向
                                    currentDirecton = .DN
                                })
                        )
                }
                
                // 下一张图片，位于当前图片的右侧（屏幕外）
                NextCard(name: photos[currentIndex+1])
                    .offset(rightNextOffset)
            }
            .offset(hOffset)
        }
        .overlay(alignment: .bottom) {
            controlButton
        }
    }
    
    @ViewBuilder
    var controlButton: some View {
        HStack {
            Button {
                hOffset = CGSize(width: hOffset.width - 50, height: hOffset.height)
            } label: {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(.bordered)
            
            VStack {
                Button {
                    hOffset = CGSize(width: hOffset.width, height: hOffset.height - 50)
                } label: {
                    Image(systemName: "chevron.up")
                }
                .buttonStyle(.bordered)
                Button("还原") {
                    hOffset = .zero
                }
                .buttonStyle(.bordered)
                
                Button {
                    hOffset = CGSize(width: hOffset.width, height: hOffset.height + 50)
                } label: {
                    Image(systemName: "chevron.down")
                }
                .buttonStyle(.bordered)
            }
            
            Button {
                hOffset = CGSize(width: hOffset.width + 50, height: hOffset.height)
            } label: {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(.bordered)
        }
        .fontWeight(.bold)
        .accentColor(.white)
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
}

#Preview {
    SwiftUIView2()
        .preferredColorScheme(.dark)
}
