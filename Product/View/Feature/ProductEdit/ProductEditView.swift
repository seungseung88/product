//
//  ProductEditView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/08.
//

import SwiftUI
import PhotosUI

private enum FocusedField {
    case name
    case price
    case description
}

struct ProductEditView: View {
    
    let mode: ProductEditMode
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var name: String = ""
    @State private var price: Int?
    @State private var description: String = ""
    @FocusState private var focusedField: FocusedField?
    
    @Environment(\.dismiss) private var dismiss
    
    init(mode: ProductEditMode) {
        self.mode = mode
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ImageField(imageData: $imageData, selectedItem: $selectedItem)
                    NameField(name: $name, focusedField: $focusedField)
                    PriceField(price: $price, focusedField: $focusedField)
                    DescriptionField(description: $description, focusedField: $focusedField)
                }
                .padding(16)
                .background {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focusedField = nil
                        }
                }
                
            }
            .navigationTitle(mode.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            CompleteButton(buttonLabel: mode.buttonLabel) {
                dismiss()
            }
        }
        .onAppear {
            setupInitialData()
        }
    }
    
    private func setupInitialData() {
        if case let .edit(productId) = mode {
            if let product = ProductStubProvider.stubbedProducts.first(where: { $0.id == productId }) {
                self.name = product.name
                self.price = product.price
                self.description = product.description
                self.imageData = product.imageData
            }
        }
    }
    
}

private struct ImageField: View {
    @Binding var imageData: Data?
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Color(.secondarySystemBackground)
                .overlay {
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera")
                            Text("사진 추가")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}

private struct NameField: View {
    @Binding var name: String
    @FocusState.Binding var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("상품명")
                .font(.headline)
            
            TextField("상품명 입력", text: $name)
                .focused($focusedField, equals: .name)
                .font(.subheadline)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                        .stroke(focusedField == .name ? .blue : .clear, lineWidth: 1)
                }
        }
    }
}

private struct PriceField: View {
    @Binding var price: Int?
    @FocusState.Binding var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("판매 가격")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text("₩")
                    .foregroundStyle(.secondary)
                
                TextField("판매가격 입력", value: $price, format: .number)
                    .focused($focusedField, equals: .price)
                    .keyboardType(.numberPad)
            }
            .font(.subheadline)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
                    .stroke(focusedField == .price ? .blue : .clear, lineWidth: 1)
            }
        }
    }
}

private struct DescriptionField: View {
    @Binding var description: String
    @FocusState.Binding var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("상품설명")
                .font(.headline)
            
            TextField("상품설명 입력", text: $description, axis: .vertical)
                .focused($focusedField, equals: .description)
                .font(.subheadline)
                .frame(minHeight: 160, alignment: .top)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                        .stroke(focusedField == .description ? .blue : .clear, lineWidth: 1)
                }
        }
    }
}

private struct CompleteButton: View {
    let buttonLabel: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonLabel)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        
    }
}

#Preview("신규 화면") {
    ProductEditView(mode: .create)
}

#Preview("편집 화면") {
    ProductEditView(mode: .edit(productId: "1"))
}
