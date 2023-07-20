//
//  SearchMusicView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SearchMusicView: View {
    @ObservedObject var mosicViewModel = SearchMusicViewModel()
    @ObservedObject var lyricsViewModel = SelectLyricsViewModel()
    @Binding var songData: SelectedSong
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(mosicViewModel.songs) { song in
                Button(action: {
                    songData = SelectedSong(name: song.name, artist: song.artist, imageUrl: song.imageUrl)
                }) {
                    HStack {
                        AsyncImage(url: song.imageUrl) { phase in
                            switch phase {
                            case.success(let image):
                                image
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .cornerRadius(4.8)
                            case .failure(_):
                                Image(systemName: "music.note")
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(4.8)
                            case .empty:
                                Image(systemName: "music.note")
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(4.8)
                            @unknown default:
                                ProgressView()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(song.name)
                                .foregroundColor(Color(hex: 0x111111))
                                .font(.system(size: 14.48276))
                            Text(song.artist)
                                .foregroundColor(Color(hex: 0x767676))
                                .font(.system(size: 14.48276))
                        }
                        .padding()
                    }
                }
                .background(
                    NavigationLink(
                        destination: SelectLyricsView(mosicViewModel: mosicViewModel, lyricsViewModel: lyricsViewModel, songData: $songData),
                        isActive: Binding<Bool>(get: { songData != nil }, set: { _ in })
                    ) {
                        EmptyView()
                    }
                )
            }
            .listStyle(.plain)
            .searchable(text: $mosicViewModel.searchTerm)
        }
        .navigationTitle("노래 검색")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
}
