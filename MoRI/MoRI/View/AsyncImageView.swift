//
//  AsyncImageView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .padding(.leading, 35)
        } placeholder: {
            Image(systemName: "music.note")
                .resizable()
                .frame(width: 56, height: 56)
                .cornerRadius(4.8)
        }
    }
}
