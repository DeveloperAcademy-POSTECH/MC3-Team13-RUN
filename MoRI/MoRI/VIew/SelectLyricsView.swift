//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SelectLyricsView: View {
    @ObservedObject var viewModel: SearchMusicViewModel
    @ObservedObject var selectedViewModel: SelectLyricsViewModel
    @Binding var songData: SelectedSong
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack {
                AsyncImage(url: songData.imageUrl)
                    .frame(width: 56, height: 56, alignment: .center)
                   
                Spacer()
                
                VStack{
                    Text(songData.name)
                        .foregroundColor(Color(hex: 0x111111))
                        .font(.system(size: 14.48276))
                    Text(songData.artist)
                        .foregroundColor(Color(hex: 0x767676))
                        .font(.system(size: 14.48276))
                }
                
                Spacer()
            }
            ScrollView{
                VStack {
                    ForEach(selectedViewModel.lyrics, id: \.self) { lyricLine in
                        Text(selectedViewModel.removeCharactersInsideBrackets(from: lyricLine[0]))
                            .padding()
                    }
                }
                .onAppear {
                    selectedViewModel.fetchHTMLParsingResult(songData)
                }
            }
        }
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
