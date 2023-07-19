//
//  Home.swift
//  MORI
//
//  Created by Jin Sang woo on 2023/07/19.
//



// 쓸 때 그냥 Home()으로 쓰면 바로 됩니다

import SwiftUI

struct Home: View {
    
    @State private var showImagePicker = false
    @State private var selectedColor = Color.black
    @State private var imageData: Data = .init(count: 0)
    
    var body: some View {
        
        VStack {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } else {
                Rectangle()
                    .fill(selectedColor)
                    .frame(width: 200, height: 200)
            }
            
            Button("Pick Image Color") {
                showImagePicker.toggle()
            }
            .imageColorPicker(showPicker: $showImagePicker, color: $selectedColor)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(showPicker: $showImagePicker, imageData: $imageData)
        }
        
        
    }
}

struct colorPickerHome_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
