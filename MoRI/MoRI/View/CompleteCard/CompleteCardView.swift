//
//  CompleteCardView.swift
//  MoRI
//
//  Created by Jin Sang woo on 2023/07/24.
//

import SwiftUI

struct CompleteCardView: View {
    @StateObject var viewModel: CompleteCardViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.displayScale) var displayScale
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShareSheetShowing = false
    @State private var isButtonPressed = false
    @State private var isNavigateToMain = false
    
    @State var songData: SelectedSong = SelectedSong(name: "", artist: "", imageUrl: nil)
    
    @Binding var pureData: PureSong
    
    
    var body: some View {
        
        VStack(spacing: 0){
            
            CompleteCardTop(viewModel: viewModel, pureData: $pureData)
            
            ZStack{
                Rectangle()
                    .frame(width: 350, height: 163) .cornerRadius(20)
                    .foregroundColor(viewModel.lyricsContainerColor)
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .frame(width: 314, height: 0.5)
                    .foregroundColor(viewModel.lyricsContainerColor)
                    .blendMode(.screen)
                    .padding(.top, -81)
                Text(viewModel.card.lyrics)
                    .frame(width: 314, alignment: .leading)
                    .foregroundColor(viewModel.lyricsColor)
                    .font(.system(size: 17, weight: .medium))
                    .lineSpacing(15)
            }
            .compositingGroup()
            
            
            HStack(spacing : 16){
                
                VStack{
                    Button(action: {
                        PersistenceController().addItem(viewContext, viewModel.card.albumArtUIImage, viewModel.card.title, viewModel.card.singer, viewModel.card.date, viewModel.card.lyrics, viewModel.card.cardColor)
                        isButtonPressed.toggle()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 167, height: 60)
                                .cornerRadius(30)
                                .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                            if (!isButtonPressed) {
                                Text("저장하기")
                                    .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                                    .font(.system(size: 20, weight: .medium))
                            }
                            else {
                                Image(systemName: "checkmark")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                            }
                        }
                    }
                    .padding(.top, 33)
                }
                .disabled(isButtonPressed)
                
                VStack{
                    Button(action: {
                        NavigationUtil.popToRootView()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 167, height: 60)
                                .cornerRadius(30)
                                .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                            Text("메인으로")
                                .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                    .padding(.top, 33)
                }
                
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image(uiImage:viewModel.card.albumArtUIImage).resizable().ignoresSafeArea().scaledToFill().blur(radius: 20))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: shareButton)
    }
    
    var backButton: some View {
        
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
    
    
    
    var shareButton: some View {
        Button(action : {
            InstagramShare.shareToInstagramStories(viewModel: viewModel, displayScale: displayScale)
        }) {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
    
    
    
    
//    func shareToInstagramStories() {
//
//
//        let stickerImageData = ExtractImage().renderSticker(view: ShareView(albumArt: viewModel.card.albumArtUIImage, singer: viewModel.card.singer, title: viewModel.card.title, cardColor: viewModel.card.cardColor, lyrics: viewModel.card.lyrics, lyricsContainerColor: viewModel.lyricsContainerColor, lyricsColor: viewModel.lyricsColor), scale: displayScale)?.pngData()
//        let blurredImage = ExtractImage().renderBackground(view: ShareBack(albumArt: viewModel.card.albumArtUIImage), scale: displayScale)?.pngData()
//
//
//
//        let urlScheme = URL(string: "instagram-stories://share?source_application=\(Bundle.main.bundleIdentifier ?? "")")
//        if let urlScheme = urlScheme {
//            if UIApplication.shared.canOpenURL(urlScheme) {
//
//                var pasteboardItems: [[String : Any]]? = nil
//                if let stickerImageData = stickerImageData {
//                    pasteboardItems = [
//                        [
//                            "com.instagram.sharedSticker.stickerImage": stickerImageData,
//                            "com.instagram.sharedSticker.backgroundImage": blurredImage as Any
//
//                        ]
//                    ]
//                }
//
//                let pasteboardOptions = [
//                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
//                ]
//
//                if let pasteboardItems = pasteboardItems {
//                    UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
//                }
//
//                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
//            } else {
//                print("Something went wrong. Maybe Instagram is not installed on this device?")
//            }
//        }
//    }
    
    
}


struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need for update in this case
    }
}


