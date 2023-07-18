//
//  Song.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation

struct SongList: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}

struct SelectedSongList: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}
