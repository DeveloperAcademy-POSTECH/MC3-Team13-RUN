//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SelectLyricsView: View {
    @StateObject var viewModel: SearchSongViewModel
    @State var selectedSong: SelectedSong
    @State var imageUrl: URL?
    @State var title: String
    @State var artistName: String
    
    var body: some View {
        VStack{
            HStack {
                AsyncImage(url: imageUrl)
                    .frame(width: 56, height: 56, alignment: .center)
                   

                Spacer()
                
                VStack{
                    Text("\(title)")
                        .foregroundColor(Color(hex: 0x111111))
                        .font(.system(size: 14.48276))
                    Text("\(artistName)")
                        .foregroundColor(Color(hex: 0x767676))
                        .font(.system(size: 14.48276))
                }
                
                Spacer()
            }
            
//            LyricsView(title: title, artistName: artistName)
        
        }
    }
}

