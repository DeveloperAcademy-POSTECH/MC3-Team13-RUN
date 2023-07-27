//
//  CompleteCardTop.swift
//  MoRI
//
//  Created by Jin Sang woo on 2023/07/24.
//

import SwiftUI

struct CompleteCardTop: View {
    @StateObject var viewModel: CompleteCardViewModel

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
                    Text(viewModel.card.singer + "-" + viewModel.card.date)
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


struct CompleteCardTop_Previews: PreviewProvider {
    static var previews: some View {
        CompleteCardTop(viewModel: CompleteCardViewModel(card: Card(albumArtUIImage: UIImage(named: "test") ?? UIImage(), title: "커다란", singer: "민수", lyrics: "사랑은 보이지 않는 곳에 흔적을 남기지\n사람은 고스란히 느낄 수가 있지\n서로를 향하는 마음이 진심인지\n참 신기하게도 알 수가 있어", cardColor: .gray)))
    }
}
