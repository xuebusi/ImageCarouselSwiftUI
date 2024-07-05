//
//  SwiftUIView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

import SwiftUI

struct SwiftUIView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @State private var movies: [Movie] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            itemCard(index: currentIndex - 1)
            
            itemCard(index: currentIndex)
            
            itemCard(index: currentIndex + 1)
        }
        .frame(width: screenWidth * 3)
        .onAppear {
            movies = (1...8).map({ Movie(thumb: "m\($0)") })
            
            for movie in movies {
                print(movie.thumb)
            }
        }
        .overlay(alignment: .center) {
            HStack {
                Button("上一张") {
                    currentIndex = max(0, currentIndex - 1)
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentIndex == 0)
                Button("下一张") {
                    currentIndex = min(currentIndex + 1, movies.count - 1)
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentIndex == movies.count - 1)
            }
        }
    }
    
    @ViewBuilder
    func itemCard(index: Int) -> some View {
        if existIndex(index: index) {
            Image(movies[index].thumb)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth)
                .frame(height: screenHeight)
                .onAppear {
                    print("\(index)加载")
                }
                .onDisappear {
                    print("\(index)已销毁")
                }
        } else {
            Rectangle()
                .fill(.secondary)
                .frame(width: screenWidth, height: screenHeight)
        }
    }
}

extension SwiftUIView {
    func existIndex(index: Int) -> Bool {
        return !movies.isEmpty && index >= 0 && index < movies.count
    }
}

#Preview {
    SwiftUIView()
        .preferredColorScheme(.dark)
}
