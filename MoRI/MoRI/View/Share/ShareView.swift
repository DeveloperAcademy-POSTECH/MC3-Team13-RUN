//
//  ShareView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/28.
//

import SwiftUI

struct ShareView: View {
    let albumArt: UIImage
    let singer: String
    let title: String
    let cardColor: Color
    let lyrics: String
    let lyricsContainerColor: Color
    let lyricsColor: Color
    var body: some View {
        VStack(spacing: 0){
            ShareTop(albumArt: albumArt, singer: singer, title: title, cardColor: cardColor, lyricsColor: lyricsColor)
            ZStack{
                Rectangle()
                .frame(width: 296, height: 163) .cornerRadius(20)
                .foregroundColor(lyricsContainerColor)
                Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .frame(width: 265.55, height: 0.5)
                .foregroundColor(lyricsContainerColor)
                .blendMode(.screen)
                .padding(.top, -82)
                Text(lyrics)
                .frame(width: 268.94, alignment: .leading)
                .foregroundColor(lyricsColor)
                .font(.custom(FontsManager.Pretendard.regular, size: 14.42))
                .lineSpacing(12.73)
                .lineLimit(4)
            }
            .compositingGroup()
        }
        .compositingGroup()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(albumArt: UIImage(named: "test") ?? UIImage(),singer: "민수", title: "커다란", cardColor: .gray03Color, lyrics: "사랑은 보이지 않는 곳에 흔적을 남기지\n사람은 고스란히 느낄 수가 있지\n서로를 향하는 마음이 진심인지\n참 신기하게도 알 수가 있어\nasdasdsad", lyricsContainerColor: .gray02Color, lyricsColor: .whiteColor)
    }
}
