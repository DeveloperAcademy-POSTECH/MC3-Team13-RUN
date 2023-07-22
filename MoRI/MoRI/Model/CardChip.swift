//
//  CardChip.swift
//  MoRI
//
//  Created by OhSuhyun on 2023/07/20.
//

import SwiftUI

struct CardChip: View {    // 색상표
    let title: String
    let singer: String
    let date: String
    let lyrics: String
    let image: UIImage
    let scale: CGFloat
    let heightView: CGFloat // 카드 출력 형태에 따른 높이
    
    var body: some View {
        let width: CGFloat = 350*scale
        let height: CGFloat = heightView*scale
        
        ZStack {
            Image(uiImage: image)    // 이미지 에셋 없어서 임시 사용
                .resizable()
                .frame(width: width, height: heightView)
            VStack {
                Text(title)  // 제목
                Text(singer)  // 아티스트
                Text(date) // 날짜
                Text(lyrics)  // 가사
            }
                .font(Font.custom("HelveticaNeue-Bold", size: 30*scale))
                .padding(3)
                .foregroundColor(.white)
                .frame(width: width, height: height, alignment: .top)
        }
        .background(Color.teal) // 이미지 에셋 없어서 임시 사용
    }
    
    init(title: String, singer: String, date: String, lyrics: String, image: UIImage, scale: CGFloat, heightView: CGFloat) {
        self.title = title
        self.singer = singer
        self.date = date
        self.lyrics = lyrics
        self.image = image
        self.scale = scale
        self.heightView = heightView
    }
}


//struct CardChip_Previews: PreviewProvider {
//    static var previews: some View {
//        CardChip(name: "index",
//                 image: UIImage(data: "https://static.wixstatic.com/media/2bf4f7_3cef257862174c4c893cd4a802fde28f~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/2bf4f7_3cef257862174c4c893cd4a802fde28f~mv2.jpg")!,
//                 scale: 1,
//                 type: "all"
//        )
//    }
//}
