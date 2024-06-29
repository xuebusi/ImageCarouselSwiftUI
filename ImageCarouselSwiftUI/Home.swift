//
//  Home.swift
//  MovieStreamingUI
//
//  Created by Shameem Reza on 30/3/22.
//

import SwiftUI

struct Home: View {
    @State var currentIndex: Int = 0
    @State var selectedDirection: Direction = .horizontal
    
    enum Direction: String, CaseIterable {
        case horizontal = "水平"
        case vertical = "垂直"
        case layer = "层叠"
    }
    
    struct Movie: Identifiable {
        var id = UUID().uuidString
        var movieThumb: String
    }
    
    let movieList = [
        Movie(movieThumb: "m1"),
        Movie(movieThumb: "m2"),
        Movie(movieThumb: "m3"),
        Movie(movieThumb: "m4"),
        Movie(movieThumb: "m5"),
        Movie(movieThumb: "m6"),
        Movie(movieThumb: "m7"),
        Movie(movieThumb: "m8"),
    ]
    
    @State var movies: [Movie] = []
    
    init() {
        self.movies = movieList
    }
    
    var body: some View {
        ZStack {
            //BGView()
            
            VStack {
                if selectedDirection == .horizontal {
                    /// - 水平滚动
                    ImageCarouselHorizontal(
                        spacing: 20,
                        trialingSpace:40,
                        index: $currentIndex,
                        items: movies
                    ) { movie in
                        Image(movie.movieThumb)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else if selectedDirection == .vertical {
                    /// - 垂直滚动
                    ImageCarouselVertical(
                        spacing: 20,
                        trialingSpace:40,
                        index: $currentIndex,
                        items: movies
                    ) { movie in
                        Image(movie.movieThumb)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.top, 70)
                } else {
                    if !movies.isEmpty {
                        ImageCarouselLayer(items: $movies) { movie in
                            Image(movie.movieThumb)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(20)
                        } onItemRemoved: { movie in
                            print("图片\(movie.movieThumb)被移除了")
                        }
                    } else {
                        Text("没有图片了")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .overlay(alignment: .top) {
                Picker("", selection: $selectedDirection) {
                    ForEach(Direction.allCases, id: \.rawValue) { direction in
                        Text("\(direction.rawValue)")
                            .tag(direction)
                    }
                }
                .pickerStyle(.segmented)
                .padding(20)
                .background(.ultraThinMaterial)
                .onAppear {
                    self.movies = movieList
                }
                .onChange(of: selectedDirection) { _, _ in
                    self.movies = movieList
                }
            }
        }
    }
    
    @ViewBuilder
    func BGView() -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            
            TabView(selection: $currentIndex) {
                ForEach(movies.indices, id: \.self) {index in
                    Image(movies[index].movieThumb)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
            
            LinearGradient(colors: [
                .black,
                .clear,
            ], startPoint: .top, endPoint: .bottom)
            
            Rectangle()
                .fill(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
