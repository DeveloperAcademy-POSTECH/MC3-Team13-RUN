//
//  ShareTop.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/28.
//

import SwiftUI

struct ShareTop: View {
    let albumArt: UIImage
    let singer: String
    let title: String
    let cardColor: Color
    let lyricsColor: Color
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Image(uiImage: albumArt)
                    .resizable()
                    .frame(width: 296, height: 296)
                    .cornerRadius(300, corners: .topRight)
                    .cornerRadius(20, corners: .topLeft)
                Circle()
                    .frame(width: 17.76, height: 17.76)
                    .padding(.top, -135)
                    .padding(.leading, -135)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            ZStack(alignment: .top){
                Rectangle()
                    .frame(width: 296, height: 62.78)
                    .cornerRadius(16.9, corners: [.bottomLeft, .bottomRight])
                    .foregroundColor(cardColor)
                VStack(spacing: 0){
                    Text(title)
                        .font(.custom(FontsManager.Pretendard.medium, size: 28.84))
                        .foregroundColor(lyricsColor)
                        .frame(width: 296, height: 28.84, alignment: .center)
                        .minimumScaleFactor(0.5)
                    Text(singer)
                        .frame(width: 233, height: 11.88, alignment: .trailing)
                        .font(.custom(FontsManager.Pretendard.regular, size: 11.88))
                        .foregroundColor(lyricsColor)
                        .blendMode(.softLight)
                }
                .padding(.top, 17)
            }.compositingGroup()
        }
    }
}

struct ShareTop_Previews: PreviewProvider {
    static var previews: some View {
        ShareTop(albumArt: UIImage(named: "test") ?? UIImage(), singer: "민수", title: "이름 없는 거리", cardColor: .gray03Color, lyricsColor: .whiteColor)
    }
}

