//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct SelectLyricsView: View {
    @StateObject var viewModel: SearchSongViewModel
    @State var imageUrl: URL?
    @State var title: String
    @State var artistName: String
    
    @Environment(\.dismiss) private var dismiss
    
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
            
           LyricsView(title: title, artistName: artistName)
        
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

//MARK: 실제 가사가 보여지는 부분
struct LyricsView: View {
    @ObservedObject var viewModel = SearchLyricsViewModel()
    @State var title: String
    @State var artistName: String
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(viewModel.lyrics, id: \.self) { lyricLine in
                    Text( viewModel.removeCharactersInsideBrackets(from: lyricLine[0]))
                        .padding()
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchHTMLParsingResult(artist: artistName, title: title)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}
