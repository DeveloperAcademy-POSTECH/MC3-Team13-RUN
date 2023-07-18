//
//  SearchMusicView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

//struct SearchMusicView: View {
//
//    @ObservedObject var viewModel = SearchSongViewModel()
//    @FocusState private var isTextFieldFocused: Bool
//    @State var selectedSong: SelectedSongList
//
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading){
//                HStack {
//                    Spacer()
//
//                    TextField("", text: $viewModel.searchTerm)
//                        .padding()
//                        .frame(width: 307, height: 37)
//                        .textFieldStyle(.roundedBorder)
//                        .focused($isTextFieldFocused)
//                        .overlay(
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.gray)
//                                Spacer()
//                            }
//                                .padding(.leading, 30)
//                        )
//                    //                    .showClearButton($viewModel.searchTerm)
//                    Spacer()
//
//                    Button {} label: {
//                        Text("취소")
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundColor(.green)
//                    }
//                    Spacer()
//                }
//
//                List(viewModel.songs) { song in
//                    NavigationLink(destination: SelectLyricsView(viewModel: viewModel, selectedSong: selectedSong, imageUrl: song.imageUrl, title: replaceSpacesWithDash(in: song.name), artistName: replaceSpacesWithDash(in: song.artist))) {
//                        HStack {
//                            AsyncImage(url: song.imageUrl)
//                                .frame(width: 75, height: 75, alignment: .center)
//                            VStack(alignment: .leading) {
//                                Text(song.name)
//                                    .font(.title3)
//                                Text(song.artist)
//                                    .font(.footnote)
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .listStyle(.plain)
//                .navigationTitle("노래 검색")
//
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.isTextFieldFocused = true
//                    }
//                }
//            }
//        }
//    }
//
//    func replaceSpacesWithDash(in text: String) -> String {
//        let result = text.replacingOccurrences(of: " ", with: "-")
//        return result
//    }
//}

struct SearchMusicView: View {
    @ObservedObject var viewModel = SearchSongViewModel()
    @State var selectedSong: SelectedSongList

    var body: some View {
        NavigationStack {
            List(viewModel.songs) { song in
                NavigationLink(destination: SelectLyricsView(viewModel: viewModel, selectedSong: selectedSong, imageUrl: song.imageUrl, title: viewModel.replaceSpacesWithDash(in: song.name), artistName: viewModel.replaceSpacesWithDash(in: song.artist))) {
                    HStack {
                        AsyncImage(url: song.imageUrl)
                            .frame(width: 56, height: 56, alignment: .center)
                            .cornerRadius(4.8)
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
}
