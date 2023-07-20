//
//  CardChip.swift
//  MoRI
//
//  Created by OhSuhyun on 2023/07/20.
//

import SwiftUI

struct CardChip: View {    // 색상표
    let name: String
    let image: String
    let scale: CGFloat
    let type: String    // 카드 표현 형태
    
    var body: some View {
        let width: CGFloat = 350*scale
        let heightAll: CGFloat = 587*scale  // 카드 전체
        let heightTop: CGFloat = 350*scale  // 카드 상단부
        let heightArt: CGFloat = (587-161)*scale    // 카드 앨범아트
        var height: CGFloat {   // type에 따라 다른 높이 부여
            switch type {
            case "all":
                return heightAll
            case "top":
                return heightTop
            case "art":
                return heightArt
            default:
                return heightAll
            }
        }
        
        ZStack {
//            Image(image)
            Image(systemName: image)    // 이미지 에셋 없어서 임시 사용
                .resizable()
                .frame(width: width, height: height)
            Text(name)  // 색상 RGB 값
                .font(Font.custom("HelveticaNeue-Bold", size: 90*scale))
                .padding(3)
                .foregroundColor(.white)
                .frame(width: width, height: height, alignment: .top)
        }
        .background(Color.teal) // 이미지 에셋 없어서 임시 사용
    }
    
    init(name: String, image: String, scale: CGFloat, type: String) {
        self.name = name
        self.image = image
        self.scale = scale
        self.type = type
    }
}


struct CardChip_Previews: PreviewProvider {
    static var previews: some View {
        CardChip(name: "index",
                 image: "square",
                 scale: 1,
                 type: "all"
        )
    }
}
