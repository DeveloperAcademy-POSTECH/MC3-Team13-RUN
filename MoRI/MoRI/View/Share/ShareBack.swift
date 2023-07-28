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
        Rectangle()
            .foregroundColor(.clear)
            .background(Image(uiImage: albumArt).resizable().ignoresSafeArea().scaledToFill().blur(radius: 20))
    }
}

struct ShareBack_Previews: PreviewProvider {
    static var previews: some View {
        ShareBack(albumArt: UIImage(named: "test") ?? UIImage())
    }
}
