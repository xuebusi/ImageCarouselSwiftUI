//
//  PhotoSelectionView.swift
//  ImageCarouselSwiftUI
//
//  Created by shiyanjun on 2024/7/5.
//

import SwiftUI

// 图片选择器组件使用示例
struct PhotoSelectionExampleView: View {
    let photos = (1...10).map({ GridPhoto(image: "Pic \($0)") })
    
    var body: some View {
        NavigationStack {
            PhotoSelectionView(list: photos) { photo in
                Image(photo.image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } onSelectionChange: { ids in
                for id in ids {
                    print(id)
                }
                print("----------------------------")
            }
        }
    }
}

// 枚举定义按钮的不同状态
enum ButtonTitle {
    case selectAll
    case deselectAll
    case cancelSelect
    
    var text: String {
        switch self {
        case .selectAll:
            return "全选整理"
        case .deselectAll:
            return "取消全选"
        case .cancelSelect:
            return "取消选择"
        }
    }
}

struct GridPhoto: Identifiable {
    var id = UUID().uuidString
    var image: String
}

// 图片选择器组件
struct PhotoSelectionView<Content: View, T: Identifiable>: View {
    let screenWidth = UIScreen.main.bounds.width
    private let photoSpacing: CGFloat = 2
    
    @State var list: [T]
    @State var selectedIds: Set<T.ID> = []
    @State private var isSelectionEnabled = false
    @State private var buttonText: ButtonTitle = .selectAll
    
    var content: (T) -> Content
    var onSelectionChange: ((Set<T.ID>) -> Void)? = nil
    
    // 自定义初始化方法
    init(list: [T],
         @ViewBuilder content: @escaping (T) -> Content,
         onSelectionChange: ((Set<T.ID>) -> Void)? = nil) {
        self._list = State(wrappedValue: list)
        self.content = content
        self.onSelectionChange = onSelectionChange
    }
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 2)]
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(list) { item in
                    PhotoView(item: item, isSelected: selectedIds.contains(item.id), isSelectionEnabled: isSelectionEnabled) { item in
                        content(item)
                    }
                    .frame(
                        width: screenWidth/3-photoSpacing,
                        height: screenWidth/3-photoSpacing
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isSelectionEnabled {
                            toggleSelection(item.id)
                        }
                    }
                }
            }
        }
        .navigationTitle("照片选择")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button(action: {
                isSelectionEnabled = false
                selectedIds.removeAll()
                buttonText = .selectAll
                onSelectionChange?(selectedIds)
            }) {
                Text("完成")
            }.opacity(isSelectionEnabled ? 1 : 0),
            trailing: Button(action: {
                buttonTapped()
            }) {
                Text(buttonText.text)
            }
        )
    }
    
    // 按钮点击事件处理
    private func buttonTapped() {
        switch buttonText {
        case .selectAll:
            // 全选所有照片
            selectedIds = Set(list.map { $0.id })
            buttonText = .deselectAll
            isSelectionEnabled = true
        case .deselectAll:
            // 取消全选
            selectedIds.removeAll()
            buttonText = .selectAll
            //isSelectionEnabled = false
        case .cancelSelect:
            // 取消选择
            selectedIds.removeAll()
            buttonText = .selectAll
            //isSelectionEnabled = false
        }
        // 回调选中状态变化
        onSelectionChange?(selectedIds)
    }
    
    // 切换照片选中状态
    private func toggleSelection(_ id: T.ID) {
        if selectedIds.contains(id) {
            selectedIds.remove(id)
        } else {
            selectedIds.insert(id)
        }
        updateButtonText()
        // 回调选中状态变化
        onSelectionChange?(selectedIds)
    }
    
    // 更新按钮文字
    private func updateButtonText() {
        if selectedIds.isEmpty {
            buttonText = .selectAll
        } else if selectedIds == Set(list.map { $0.id }) {
            buttonText = .deselectAll
        } else {
            buttonText = .cancelSelect
        }
    }
}

struct PhotoView<Content: View, T: Identifiable>: View {
    let item: T
    let isSelected: Bool
    let isSelectionEnabled: Bool
    var content: (T) -> Content
    
    init(item: T, isSelected: Bool, isSelectionEnabled: Bool, @ViewBuilder content: @escaping (T) -> Content) {
        self.item = item
        self.isSelected = isSelected
        self.isSelectionEnabled = isSelectionEnabled
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack(alignment: .topTrailing) {
                content(item)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                
                if isSelectionEnabled {
                    RingView(isSelected: isSelected)
                        .padding(10)
                }
            }
        }
    }
}

struct RingView: View {
    let isSelected: Bool
    private let lineWidth: CGFloat = 3
    
    var body: some View {
        Circle()
            .stroke(Color.white.opacity(0.6), lineWidth: lineWidth)
            .frame(width: 24-lineWidth, height: 24-lineWidth)
            .overlay {
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
                    .opacity(isSelected ? 1 : 0)
            }
    }
}

struct PhotoSelectionExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectionExampleView()
            .preferredColorScheme(.dark)
    }
}
