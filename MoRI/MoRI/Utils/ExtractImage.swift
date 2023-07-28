//
//  ExtractImage.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/28.
//

import SwiftUI

struct ExtractImage{
    @MainActor func renderSticker(view: ShareView, scale: CGFloat) ->Image {
        let renderer = ImageRenderer(content: view)

        renderer.scale = scale

        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(uiImage: UIImage())
    }
    
    @MainActor func renderBackground(view: ShareBack, scale: CGFloat) ->Image {
        let renderer = ImageRenderer(content: view)

        renderer.scale = scale

        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(uiImage: UIImage())
    }
}
