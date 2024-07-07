//
//  ImageCarouselSwiftUIApp.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/6/28.
//

import SwiftUI

@main
struct ImageCarouselSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //CarouselView()
            //PhotoSelectionExampleView()
            PhotoTabView()
                .preferredColorScheme(.dark)
        }
    }
}
