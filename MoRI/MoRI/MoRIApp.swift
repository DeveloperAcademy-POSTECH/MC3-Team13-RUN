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

    
    var body: some Scene {
        WindowGroup {
//                        ContentView()
            //            SearchMusicView(selectedSong: selectedSong)
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
