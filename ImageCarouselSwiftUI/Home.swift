//
//  Home.swift
//  MovieStreamingUI
//
//  Created by Shameem Reza on 30/3/22.
//

import SwiftUI

struct Home: View {
    @State var currentIndex: Int = 0
    
    struct Movie: Identifiable {
        var id = UUID().uuidString
        var movieThumb: String
    }

    var movies: [Movie] = [
        Movie(movieThumb: "m1"),
        Movie(movieThumb: "m2"),
        Movie(movieThumb: "m3"),
        Movie(movieThumb: "m4"),
        Movie(movieThumb: "m5"),
        Movie(movieThumb: "m6"),
        Movie(movieThumb: "m7"),
        Movie(movieThumb: "m8"),
    ]
    
    var body: some View {
        ZStack {
            BGView()
            
            VStack {
                ImageCarousel(
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
