//
//  ShowOffsetView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/3.
//

import SwiftUI

struct ShowOffsetViewExample: View {
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        VStack {
            ShowOffsetView(offset: $offset) {
                Image("Pic 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    //.offset(x: offset.x, y: offset.y)
            }
            .overlay {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(String(format: "%.0f", offset.x))")
                    Text("\(String(format: "%.0f", offset.y))")
                }
                .padding()
                .background(.blue)
                .cornerRadius(10)
            }
            .overlay(alignment: .bottom) {
                VStack {
                    HStack {
                        Button("<-") {
                            offset.x -= 100
                        }
                        .buttonStyle(.borderedProminent)
                        Button("->") {
                            offset.x += 100
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}


struct ShowOffsetView<Content: View>: View {
    @Binding var offset: CGPoint
    var content: () -> Content
    
    var body: some View {
        content()
            .overlay(
                GeometryReader { innerGeometry in
                    Color.clear
                        .onAppear {
                            self.offset = CGPoint(
                                x: innerGeometry.frame(in: .global).minX,
                                y: innerGeometry.frame(in: .global).minY
                            )
                        }
                        .onChange(of: innerGeometry.frame(in: .global), { _, newFrame in
                            self.offset = CGPoint(
                                x: newFrame.minX,
                                y: newFrame.minY
                            )
                        })
                }
            )
    }
}

struct ShowOffsetView_Previews: PreviewProvider {
    static var previews: some View {
        ShowOffsetViewExample()
            .preferredColorScheme(.dark)
    }
}
