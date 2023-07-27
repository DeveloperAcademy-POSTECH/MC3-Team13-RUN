//
//  CardDetailTop.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI

struct CardDetailTop: View {
    @StateObject var viewModel: CardDetailViewModel

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
                    Text(viewModel.card.title)
                        .font(.system(size: 34, weight: .medium))
                        .foregroundColor(viewModel.lyricsColor)
                        .frame(height: 34)
                    Text(viewModel.card.singer)
                        .frame(width: 314, height: 22, alignment: .leading)
                        .font(.system(size: 14, weight: .regular))
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