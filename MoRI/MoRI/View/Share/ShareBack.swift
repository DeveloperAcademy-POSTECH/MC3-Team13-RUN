//
//  ShareBack.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/28.
//

import SwiftUI

struct ShareBack: View {
    let albumArt: UIImage
    var body: some View {
        Image(uiImage: albumArt)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width:720, height:1080)
            .blur(radius: 20)
        
    }
}

struct ShareBack_Previews: PreviewProvider {
    static var previews: some View {
        ShareBack(albumArt: UIImage(named: "test") ?? UIImage())
    }
}
