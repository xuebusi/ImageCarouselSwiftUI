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
    @State private var movies: [Movie] = []
    @State private var currentIndex: Int = 0
    @State private var offsetStart: CGFloat = 0
    @State private var dragOffsset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            itemCard(index: currentIndex - 1)
                .background(.red.opacity(0.2))
            
            itemCard(index: currentIndex)
                .background(.green.opacity(0.2))
            
            itemCard(index: currentIndex + 1)
                .background(.purple.opacity(0.2))
        }
        .frame(width: screenWidth * (currentIndex == 0 || currentIndex == movies.count - 1 ? 2 : 3), height: screenHeight)
        .ignoresSafeArea()
        .offset(x: dragOffsset)
        .onAppear {
            movies = (1...8).map({ Movie(thumb: "m\($0)") })
            
            for movie in movies {
                print(movie.thumb)
            }
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    dragOffsset = offsetStart + value.translation.width
                })
                .onEnded({ value in
                    offsetStart = dragOffsset
                })
        )
        .overlay(alignment: .center) {
            VStack {
                HStack {
                    Button("上一张") {
                        currentIndex = max(0, currentIndex - 1)
                        dragOffsset = offsetStart + screenWidth
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentIndex == 0)
                    Button("下一张") {
                        currentIndex = min(currentIndex + 1, movies.count - 1)
                        dragOffsset = offsetStart - screenWidth
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentIndex == movies.count - 1)
                }
                Text("\(currentIndex)")
                    .font(.largeTitle)
            }
        }
    }
    
    @ViewBuilder
    func itemCard(index: Int) -> some View {
        if existIndex(index: index) {
            Image(movies[index].thumb)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth, height: screenHeight)
                .onAppear {
                    print("\(index)加载")
                }
                .onDisappear {
                    print("\(index)已销毁")
                }
        }
        else {
            Rectangle()
                .fill(.red.opacity(0.3))
                .frame(width: screenWidth, height: screenHeight)
        }
    }
}

extension SwiftUIView2 {
    func existIndex(index: Int) -> Bool {
        return !movies.isEmpty && index >= 0 && index < movies.count
    }
}

#Preview {
    SwiftUIView2()
        .preferredColorScheme(.dark)
}
