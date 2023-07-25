//
//  MoRIApp.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import SwiftUI

@main
struct MoRIApp: App {
//    private let selectedSong = SelectedSong(name: "", artist: "", imageUrl: nil)
//    @State var songData: SelectedSong = SelectedSong(name: "", artist: "", imageUrl: nil)

    let persistenceController = PersistenceController.shared
    @State var songData: SelectedSong = SelectedSong(name: "", artist: "", imageUrl: nil)
    
    var body: some Scene {
        WindowGroup {
//                        ContentView()
            //            SearchMusicView(selectedSong: selectedSong)
//             MainView()
//            MainView(songData: songData)
            ArchiveCardChipView(songData: songData)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
