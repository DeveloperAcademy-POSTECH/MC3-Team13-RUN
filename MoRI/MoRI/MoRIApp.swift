//
//  MoRIApp.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import SwiftUI

@main
struct MoRIApp: App {
    let selectedSong = SelectedSongList(name: "", artist: "", imageUrl: nil)
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            SearchMusicView(selectedSong: selectedSong)
            MainView(selectedSong: selectedSong)
        }
    }
}
