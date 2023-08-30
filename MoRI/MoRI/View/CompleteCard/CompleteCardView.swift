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
    
    private let screenWidth = UIScreen.main.bounds.size.width

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
                    .font(.custom(FontsManager.Pretendard.medium, size: 17))
                    .lineLimit(4)
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
                                .foregroundColor(.gray03Color)
                            if (!isButtonPressed) {
                                Text("저장하기")
                                    .foregroundColor(.primaryColor)
                                    .font(.custom(FontsManager.Pretendard.medium, size: 20))
                            }
                            else {
                                Image(systemName: "checkmark")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primaryColor)
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
                                .foregroundColor(.primaryColor)
                            Text("메인으로")
                                .foregroundColor(.gray04Color)
                                .font(.custom(FontsManager.Pretendard.medium, size: 20))
                        }
                    }
                    .padding(.top, 33)
                }
                
            }
            
            
        }
        .scaleEffect(screenWidth/393)
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


