//
//  SearchMusicView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SearchMusicView: View {
    @ObservedObject var viewModel = SearchSongViewModel()
    
//    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(viewModel.songs) { song in
                NavigationLink(destination: SelectLyricsView(viewModel: viewModel,
                                                             imageUrl: song.imageUrl,
                                                             title: viewModel.replaceSpacesWithDash(in: song.name),
                                                             artistName: viewModel.replaceSpacesWithDash(in: song.artist)))
                {
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
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchTerm)
        }
        .navigationTitle("노래 검색")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button(action: {
//            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
}
