//
//  CardDetailView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI

struct CardDetailView: View {
    @StateObject var viewModel: CardDetailViewModel
    var body: some View {
        VStack(spacing: 0){
            CardDetailTop(viewModel: viewModel)
            
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
        }
        .compositingGroup()
        .shadow(radius: 5, x: 8, y: -4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image(uiImage:viewModel.card.albumArtUIImage).resizable().ignoresSafeArea().scaledToFill().blur(radius: 20))
    }
}
