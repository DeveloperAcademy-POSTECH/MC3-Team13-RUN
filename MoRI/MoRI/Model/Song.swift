//
//  Song.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation

internal struct SongList: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}

internal struct SelectedSong: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}
