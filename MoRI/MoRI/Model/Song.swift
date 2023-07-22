//
//  Song.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation

internal struct SongList: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var artist: String
    var imageUrl: URL?
}

//internal struct SelectedSong: Identifiable, Hashable {
//    var id = UUID()
//    var name: String
//    var artist: String
//    var imageUrl: URL?
//}

struct SelectedSong {
    var id = UUID()
    var name: String
    var artist: String
    var imageUrl: URL?
}
