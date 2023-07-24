//
//  EditCardViewModel.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI
import Combine

final class EditCardViewModel: ObservableObject {
    @Published public var card:Card
    @Published public var lyricsContainerColor: Color = .clear
    @Published public var lyricsColor: Color = .clear
    @Published public var draggedOffset: CGSize
    @Published public var accumulatedOffset = CGSize.zero

    
    init(card: Card) {
        self.card = card
        let image = card.albumArtUIImage
        guard let cgImage = image.cgImage else {
            draggedOffset = CGSize(width: 0, height: 150)
            accumulatedOffset = CGSize(width: 0, height: 150)
            return
        }
        draggedOffset = CGSize(width: 0, height: 150)
        accumulatedOffset = CGSize(width: 0, height: 150)
    }
    public func getColorFromImagePixel(){
        let image = card.albumArtUIImage
        guard let cgImage = image.cgImage else {
            card.cardColor = .black
            return
        }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = cgImage.bitmapInfo.rawValue
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            card.cardColor = .black
            return
        }
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        let x = Int((draggedOffset.width+175)/350*225)
        let y = Int((draggedOffset.height+175)/350*225)
        let pixelData = context.data?.assumingMemoryBound(to: UInt8.self)
        let offset = bytesPerRow * y + bytesPerPixel * x
        let r = Double((pixelData?[offset])!)/225
        let g = Double((pixelData?[offset + 1])!)/225
        let b = Double((pixelData?[offset + 2])!)/225
        card.cardColor = Color(red: r, green: g, blue: b)
        changeColorsAfterCardColorChange()
    }
    
    private func changeColorsAfterCardColorChange(){
        let cardColor = card.cardColor
        let r = cardColor.components.r
        let g = cardColor.components.g
        let b = cardColor.components.b
        let cmax = max(r, g, b)
        let cmin = min(r, g, b)
        let lightness = ((cmax+cmin)/2.0)*100
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        UIColor(cardColor).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        lyricsColor = lightness >= 60 ? .black : .white
        if( 0.0 <= brightness && brightness < 0.70){
            lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness+0.1, alpha: 1.0))
        }
        else if( 0.70 <= brightness && brightness <= 0.85 ){
            lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness+0.15, alpha: 1.0))
        }
        else{
            lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness-0.15, alpha: 1.0))
        }
    }
    public func repositionDrag(){
        if(draggedOffset.width >= 170 || draggedOffset.width <= -170 || draggedOffset.height >= 170 || draggedOffset.height <= -170 ){
            draggedOffset = .zero
            accumulatedOffset = .zero
        }
    }
}
