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
                    .gesture(
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
                    )
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .overlay {
            VStack {
                Text("\(currentIndex)")
                    .font(.largeTitle)
                HStack {
                    Button("Prev") {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Next") {
                        if currentIndex < photos.count - 1 {
                            currentIndex += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button("还原") {
                    self.photos = (1...8).map({"m\($0)"})
                }
            }
        }
    }
}


#Preview {
    PhotoTabView()
        .preferredColorScheme(.dark)
}
