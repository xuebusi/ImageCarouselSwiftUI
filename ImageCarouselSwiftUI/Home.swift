//
//  Home.swift
//  MovieStreamingUI
//
//  Created by Shameem Reza on 30/3/22.
//

import SwiftUI
struct Movie: Identifiable {
    var id = UUID().uuidString
    var thumb: String
}

let movieList = [
    Movie(thumb: "m1"),
    Movie(thumb: "m2"),
    Movie(thumb: "m3"),
    Movie(thumb: "m4"),
    Movie(thumb: "m5"),
    Movie(thumb: "m6"),
    Movie(thumb: "m7"),
    Movie(thumb: "m8"),
    Movie(thumb: "m1"),
    Movie(thumb: "m2"),
    Movie(thumb: "m3"),
    Movie(thumb: "m4"),
    Movie(thumb: "m5"),
    Movie(thumb: "m6"),
    Movie(thumb: "m7"),
    Movie(thumb: "m8"),
]
struct Home: View {
    @State var currentIndex: Int = 0
    @State var selectedDirection: Direction = .star
    
    enum Direction: String, CaseIterable {
        case horizontal = "水平"
        case vertical = "垂直"
        case layer = "层叠"
        case star = "星标"
    }
    

    
    @State var movies: [Movie] = []
    
    var body: some View {
        ZStack {
            //BGView()
            
            VStack {
                if selectedDirection == .horizontal {
                    /// - 水平滚动
                    ImageCarouselHorizontal(
                        index: $currentIndex,
                        items: movies
                    ) { movie in
                        Image(movie.thumb)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else if selectedDirection == .vertical {
                    /// - 垂直滚动
                    ImageCarouselVertical(
                        index: $currentIndex,
                        items: movies
                    ) { movie in
                        Image(movie.thumb)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.top, 70)
                } else if selectedDirection == .layer {
                    if !movies.isEmpty {
                        ImageCarouselLayer(items: $movies) { movie in
                            Image(movie.thumb)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(20)
                        } onItemRemoved: { movie in
                            print("图片\(movie.thumb)被移除了")
                        }
                    } else {
                        Text("没有图片了")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    if !movies.isEmpty {
                        PhotoStarMarkCarousel(items: $movies, currentIndex: $currentIndex) { movie in
                            Image(movie.thumb)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding(.horizontal, 10)
                        } thumbnailContent: { movie in
                            Image(movie.thumb)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                        } onItemRemoved: { movie in
                            print("Movie removed: \(movie.thumb)")
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
            }
        }
    }
    
    @ViewBuilder
    func BGView() -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            
            TabView(selection: $currentIndex) {
                ForEach(movies.indices, id: \.self) {index in
                    Image(movies[index].thumb)
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
