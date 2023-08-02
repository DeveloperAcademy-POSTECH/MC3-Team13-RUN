//
//  CompleteCardTop.swift
//  MoRI
//
//  Created by Jin Sang woo on 2023/07/24.
//

import SwiftUI

struct CompleteCardTop: View {
    @StateObject var viewModel: CompleteCardViewModel
    @Binding var pureData: PureSong

    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Image(uiImage: viewModel.card.albumArtUIImage)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .cornerRadius(300, corners: .topRight)
                    .cornerRadius(30, corners: .topLeft)
                Circle()
                    .frame(width: 30, height: 30)
                    .padding(.top, -160)
                    .padding(.leading, -160)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            ZStack(alignment: .top){
                Rectangle()
                    .frame(width: 350, height: 74)
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .foregroundColor(viewModel.card.cardColor)
                VStack(spacing: 0){
                    Text(pureData.name)
                        .frame(width: 314,height: 34)
                        .font(.custom(FontsManager.Pretendard.medium, size: 34))
                        .foregroundColor(viewModel.lyricsColor)
                    Text(pureData.artist)
                        .frame(width: 314, height: 22, alignment: .leading)
                        .font(.custom(FontsManager.Pretendard.regular, size: 14))
                        .foregroundColor(viewModel.lyricsColor)
                        .blendMode(.softLight)
                }
                .padding(.top, 17)
            }.compositingGroup()
        }
        .onAppear{
            viewModel.lyricsColorsFromCard()
        }
    }
}
