//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SelectLyricsView: View {
    @StateObject var viewModel: SearchSongViewModel
    @State var selectedSong: SelectedSongList
    @State var imageUrl: URL?
    @State var title: String
    @State var artistName: String
    
    var body: some View {
        VStack{
            HStack {
                AsyncImage(url: imageUrl)
                    .frame(width: 75, height: 75, alignment: .center)

                Spacer()
                
                VStack{
                    Text("\(title)")
                        .font(.title)
                    Text("\(artistName)")
                        .font(.title3)
                }
                
                Spacer()
            }
            
//            LyricsView(title: title, artistName: artistName)
        
        }
    }
}

