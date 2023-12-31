//
//  ExtractImage.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/28.
//

import SwiftUI



struct ExtractImage{
    @MainActor func renderSticker(view: ShareView, scale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: view)

        renderer.scale = scale

        if let uiImage = renderer.uiImage {
            return uiImage
        }
        return nil
    }
    
    @MainActor func renderBackground(view: ShareBack, scale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: view)
        
        renderer.scale = scale
        
        if let uiImage = renderer.uiImage {
            return uiImage
        }
        return nil
    }
    

    

    
    
}
