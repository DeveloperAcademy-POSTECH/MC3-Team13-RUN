//
//  SearchMusicView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SearchMusicView: View {
    @ObservedObject var viewModel = SearchSongViewModel()
    @State var selectedSong: SelectedSongList
    @FocusState private var isTextFieldFocused: Bool
    @State var songTitle = ""

    var body: some View {
        NavigationStack {
            VStack{
                
                TextField("Search", text: $viewModel.searchTerm)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .focused($isTextFieldFocused)
                    
                List(viewModel.songs) { song in
                    NavigationLink(destination: SelectLyricsView(viewModel: viewModel, selectedSong: selectedSong, imageUrl: song.imageUrl, title: replaceSpacesWithDash(in: song.name), artistName: replaceSpacesWithDash(in: song.artist))) {
                        HStack {
                            AsyncImage(url: song.imageUrl)
                                .frame(width: 75, height: 75, alignment: .center)
                            VStack(alignment: .leading) {
                                Text(song.name)
                                    .font(.title3)
                                Text(song.artist)
                                    .font(.footnote)
                            }
                            .padding()
                        }
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.isTextFieldFocused = true
                    }
                }
            }
        }
    }
    
    func replaceSpacesWithDash(in text: String) -> String {
        let result = text.replacingOccurrences(of: " ", with: "-")
        return result
    }
}
