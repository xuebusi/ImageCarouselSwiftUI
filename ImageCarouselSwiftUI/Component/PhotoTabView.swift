//
//  PhotoTabView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/7.
//

import SwiftUI

/// - 使用TabView实现照片在同时水平和垂直2个方向的上滚动切换
struct PhotoTabView: View {
    @State private var currentIndex: Int = 0
    @State var photos = (1...8).map({"m\($0)"})
    
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: CGFloat = 1
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(photos.indices, id: \.self) { index in
                Image(photos[index])
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.0000001))
                    .offset(x: 0, y: offsetY)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        print("\(index)加载")
                    }
                    .onDisappear {
                        print("\(index)卸载")
                    }
                    .tag(index)
                    .tabItem {
                        Text(photos[index])
                    }
                    .onTapGesture {
                        print("\(index)")
                    }
                    .gesture(gestureHandler(index))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay {
            if !photos.isEmpty {
                ControlButtonView()
            } else {
                VStack {
                    Text("没有图片了")
                        .font(.headline)
                    
                    Button("还原") {
                        self.photos = (1...8).map({"m\($0)"})
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    func ControlButtonView() -> some View {
        HStack {
            Button {
                currentIndex = max(currentIndex - 1, 0)
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .tint(.white.opacity(0.6))
            .buttonStyle(.borderless)
            .disabled(currentIndex == 0)
            
            Spacer()
            
            Text("\(currentIndex)")
                .font(.largeTitle)
                .padding()
                .background(.blue.opacity(0.5))
                .clipShape(Circle())
            
            Spacer()
            
            Button {
                currentIndex = min(currentIndex + 1, photos.count - 1)
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .tint(.white.opacity(0.6))
            .buttonStyle(.borderless)
            .disabled(currentIndex == photos.count - 1)
        }
        .padding(.horizontal, 30)
    }
    
    /// - 手势处理
    private func gestureHandler(_ index: Int) -> some Gesture {
        DragGesture()
            .onChanged({ value in
                offsetY = value.translation.height
            })
            .onEnded({ value in
                if abs(offsetY) > screenHeight/3 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        offsetY = offsetY > 0 ? screenHeight : -screenHeight
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        photos.remove(at: index)
                        if photos.count == 1 {
                            currentIndex = 0
                        }
                        opacity = 0
                        offsetY = 0
                        scale = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            opacity = 1
                            scale = 1
                        }
                    }
                } else {
                    withAnimation {
                        offsetY = 0
                    }
                }
            })
    }
}


#Preview {
    PhotoTabView()
        .preferredColorScheme(.dark)
}
