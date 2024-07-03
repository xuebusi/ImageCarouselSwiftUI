//
//  CarouselView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/29.
//

import SwiftUI

/// - 图片切换视图
struct CarouselView: View {
    struct SVMovie: Identifiable {
        var id = UUID().uuidString
        var image: String
    }
    
    @State private var movies: [SVMovie] = []
    @State var currentIndex: Int = 0
    @State private var transitionDirection: Edge = .trailing
    
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(movies.indices, id: \.self) { index in
                    if currentIndex == index {
                        ItemCard(image: movies[currentIndex].image)
                            .transition(.asymmetric(
                                insertion: .move(edge: transitionDirection),
                                removal: .move(edge: transitionDirection == .leading ? .trailing : .leading)))
                            .animation(.easeInOut, value: currentIndex)
                            .onAppear {
                                print("\(index)加载")
                            }
                            .onDisappear {
                                print("\(index)已销毁")
                            }
                    }
                }
            }
            .onAppear {
                initData()
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Button("上一张") {
                        withAnimation {
                            transitionDirection = .leading
                            currentIndex = max(0, currentIndex - 1)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentIndex == 0)
                    Button("下一张") {
                        withAnimation {
                            transitionDirection = .trailing
                            currentIndex = min(currentIndex + 1, movies.count - 1)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentIndex == movies.count - 1)
                }
            }
        }
    }
    
    private func initData() {
        self.movies = (1...8).map({ SVMovie(image: "m\($0)") })
    }
}

struct ItemCard: View {
    let image: String
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .preferredColorScheme(.dark)
    }
}
