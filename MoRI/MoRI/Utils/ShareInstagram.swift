//
//  ShareInstagram.swift
//  MoRI
//
//  Created by Jin Sang woo on 2023/07/31.
//

import SwiftUI



class InstagramShare {
    @MainActor static func shareToInstagramStories(viewModel: CompleteCardViewModel, displayScale: CGFloat) {
        
        
        let stickerImageData = ExtractImage().renderSticker(view: ShareView(albumArt: viewModel.card.albumArtUIImage, singer: viewModel.card.singer, title: viewModel.card.title, cardColor: viewModel.card.cardColor, lyrics: viewModel.card.lyrics, lyricsContainerColor: viewModel.lyricsContainerColor, lyricsColor: viewModel.lyricsColor), scale: displayScale)?.pngData()
        let blurredImage = ExtractImage().renderBackground(view: ShareBack(albumArt: viewModel.card.albumArtUIImage), scale: displayScale)?.pngData()
        
        
        
        let urlScheme = URL(string: "instagram-stories://share?source_application=\(Bundle.main.bundleIdentifier ?? "")")
        if let urlScheme = urlScheme {
            if UIApplication.shared.canOpenURL(urlScheme) {
                
                var pasteboardItems: [[String : Any]]? = nil
                if let stickerImageData = stickerImageData {
                    pasteboardItems = [
                        [
                            "com.instagram.sharedSticker.stickerImage": stickerImageData,
                            "com.instagram.sharedSticker.backgroundImage": blurredImage as Any
                            
                        ]
                    ]
                }
                
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                ]
                
                if let pasteboardItems = pasteboardItems {
                    UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                }
                
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            } else {
                print("Something went wrong. Maybe Instagram is not installed on this device?")
            }
        }
    }
        
        
        
        
    
}
