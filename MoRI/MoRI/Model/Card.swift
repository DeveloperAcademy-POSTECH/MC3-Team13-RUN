//
//  Card.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import Foundation
import SwiftUI

struct Card {
    public var albumArtUIImage: UIImage
    public var title: String
    public var singer: String
    public var lyrics: String
    public var date: String
    public var cardColor: Color
    
    init(albumArtUIImage: UIImage, title: String, singer: String, lyrics: String, cardColor: Color) {
        self.albumArtUIImage = albumArtUIImage
        self.title = title
        self.singer = singer
        self.lyrics = lyrics
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let convertDate = dateFormatter.string(from: Date())
        self.date = convertDate
        self.cardColor = .clear
    }
}


