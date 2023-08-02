//
//  SearchMusicView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SearchMusicView: View {
    @ObservedObject var musicViewModel = SearchMusicViewModel()
    @ObservedObject var lyricsViewModel = SelectLyricsViewModel()
    @State var songData = SelectedSong(name: "", artist: "")
    @State var pureData = PureSong(name: "", artist: "")
    
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            List(musicViewModel.songs) { song in
                Button(action: {
                    songData = SelectedSong(name: musicViewModel.replaceMusicTitle(in: song.name),
                                            artist: musicViewModel.replaceArtistName(in: song.artist),
                                            imageUrl: song.imageUrl)
                    pureData = PureSong(name: song.name,
                                        artist: song.artist)
                }) {
                    HStack {
                        AsyncImage(url: song.imageUrl) { phase in
                            switch phase {
                            case.success(let image):
                                image
                                    .resizable()
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .cornerRadius(4.8)
                            case .failure(_):
                                Image("placeholder")
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(4.8)
                            case .empty:
                                Image("placeholder")
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
                                .font(.custom(FontsManager.Pretendard.medium, size: 14.48276))
                            Text(song.artist)
                                .foregroundColor(Color(hex: 0x767676))
                                .font(.custom(FontsManager.Pretendard.medium, size: 14.48276))
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .background(
                    NavigationLink(
                        destination: SelectLyricsView(musicViewModel: musicViewModel, lyricsViewModel: lyricsViewModel, songData: $songData, pureData: $pureData),
                        isActive: Binding<Bool>(get: { songData != nil }, set: { _ in })
                    ) {
                        EmptyView()
                    }
                )
            }
            .listStyle(.plain)
            .searchable(text: $musicViewModel.searchTerm)
            .navigationTitle("노래 검색")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            if(musicViewModel.songs.count == 0){
                VStack{
                    Image("searchPlaceholder")
                        .frame(width: 199.36, height: 69.93)
                        .padding(.bottom, 24.07)
                    Text("노래를 가사와 함께 저장해서\n나만의 카드를 만들어보세요")
                        .foregroundColor(.gray02Color)
                        .font(.custom(FontsManager.Pretendard.medium, size: 18))
                }
            }
        }
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
