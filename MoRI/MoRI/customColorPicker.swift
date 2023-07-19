//
//  customColorPicker.swift
//  MORI
//
//  Created by Jin Sang woo on 2023/07/19.
//

import SwiftUI
import PhotosUI


extension View{
    func imageColorPicker(showPicker: Binding<Bool>, color : Binding<Color>) -> some View{
        return self
        
            .fullScreenCover(isPresented: showPicker){
                
            } content: {
                Helper(showPicker: showPicker, color: color)
            }
    }
}


struct Helper: View{
    @Binding var showPicker : Bool
    @Binding var color : Color
    
    @State var showImagePicker : Bool = false
    @State var imageData : Data = .init(count : 0)
    
    
    var body : some View{
        
        NavigationView{
            
            VStack(spacing : 10){
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    VStack(spacing : 12){
                        
                        if let image = UIImage(data: imageData){
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                        }
                        else{
                            Image(systemName: "plus")
                                .font(.system(size : 35))
                            
                            Text("이미지 추가하기")
                                .font(.system(size : 14, weight: .light))
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
                }
                
                ZStack(alignment: .top){
                    Rectangle()
                        .fill(color)
                        .frame(height: 90)
                    
                    CustomColorPicker(color: $color)
                        .frame(width : 100, height : 50, alignment: .topLeading)
                        .clipped()
                        .offset(x : 20)
                    
                }
                
            }
            .ignoresSafeArea(.container, edges : .bottom)
            .navigationTitle("이미지 색 추출하기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("닫기"){
                    showPicker.toggle()
                }
            }
            .sheet(isPresented: $showImagePicker){
                
            } content: {
                ImagePicker(showPicker: $showImagePicker, imageData: $imageData)
            }
            
                
        }
        
    }
    
    
}




struct CustomColorPicker: UIViewControllerRepresentable{

    @Binding var color : Color
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController{
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = UIColor(color)
        
        picker.delegate = context.coordinator
        picker.title = ""
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate{
        var parent: CustomColorPicker
        
        init(parent: CustomColorPicker){
            self.parent = parent
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.color = Color(viewController.selectedColor)
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.color = Color(color)
        }
    }

}


struct ImagePicker : UIViewControllerRepresentable{
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        // 선택할 수 있는 최대 asset 수
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
//        uiViewController.view.tintColor = (color.isDarkColor ? .white : .black)
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        
        var parent : ImagePicker
        init(parent : ImagePicker){
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results : [PHPickerResult]){
            if let first = results.first{
                
                first.itemProvider.loadObject(ofClass: UIImage.self){ [self] result, err in
                    guard let image = result as? UIImage else{
                        parent.showPicker.toggle()
                        return
                    }
                    
                    parent.imageData = image.jpegData(compressionQuality: 1) ?? .init(count : 0)
                    parent.showPicker.toggle()
                }
                
            }
            else{
                parent.showPicker.toggle()
            }
        }
        
    }
    
    
}




struct customColorPicker: View {
    var body: some View {
        Text(" ")
    }
}

struct customColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        customColorPicker()
    }
}


extension Color{
    
    var isDarkColor:Bool{
        return UIColor(self).isDarkColor
    }
    
}

extension UIColor{
    
    var isDarkColor : Bool{
        var (r, g, b, a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        self.getRed(&r, green: &g, blue : &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return lum < 0.50
    }
}
