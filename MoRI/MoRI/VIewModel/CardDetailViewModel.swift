//
//  CardDetailViewModel.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/23.
//

import SwiftUI
import Combine

final class CardDetailViewModel: ObservableObject {
    @Published public var card:Card
    @Published public var lyricsContainerColor: Color = .gray
    @Published public var lyricsColor: Color = .white

    init(card: Card) {
        self.card = card
    }
    public func lyricsColorsFromCard(){
        let cardColor = card.cardColor
        print(cardColor)
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
}

