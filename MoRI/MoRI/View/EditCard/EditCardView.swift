//
//  EditCardView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI

struct EditCardView: View {
    @StateObject var viewModel: EditCardViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var pureData: PureSong
    
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            CardTop(viewModel: viewModel, pureData: $pureData)
            
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
            
            NavigationLink(destination: CompleteCardView(viewModel: CompleteCardViewModel(card: Card(albumArtUIImage: viewModel.card.albumArtUIImage, title: viewModel.card.title, singer: viewModel.card.singer, lyrics: viewModel.card.lyrics, cardColor: viewModel.card.cardColor)), pureData: $pureData)) {
                
               
                    ZStack{ Rectangle()
                            .frame(width: 350, height: 60)
                            .cornerRadius(30)
                            .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                        Text("색상 선택 완료")
                            .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                            .font(.system(size: 20, weight: .medium))
                    
                }
            }
            .padding(.top, 33)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image(uiImage:viewModel.card.albumArtUIImage).resizable().ignoresSafeArea().scaledToFill().blur(radius: 20))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}
