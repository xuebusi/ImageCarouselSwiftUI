//
//  DragableBallView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/3.
//

import SwiftUI

/// - SwiftUI拖动手势实现小球任意拖动
struct DragableBallView: View {
    @State private var ballPos: CGFloat = 0
    @State private var dragStart: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.green
            
            GeometryReader { geo in
                Circle()
                    .fill(Color.purple)
                    .frame(width: 100, height: 100)
                    .position(x: ballPos, y: 300)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.ballPos = self.dragStart + value.translation.width
                            }
                            .onEnded { _ in
                                self.dragStart = self.ballPos
                            }
                    )
                    .onAppear {
                        // 初始化球的位置为屏幕中心
                        self.ballPos = geo.size.width
                        self.dragStart = self.ballPos
                    }
                    .background {
                        VStack {
                            Text("x:\(String(format: "%.2f", ballPos))")
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
            }
        }
    }
}

#Preview {
    DragableBallView()
}
