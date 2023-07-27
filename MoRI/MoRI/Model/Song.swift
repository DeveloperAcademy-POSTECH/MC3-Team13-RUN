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

internal struct SelectedSong {
    var id = UUID()
    var name: String
    var artist: String
    var imageUrl: URL?
}

// 원본 이름, 제목을 저장하기 위한 구조체
internal struct PureSong {
    var name: String
    var artist: String
}
