//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI


struct SelectLyricsView: View {
    @ObservedObject var musicViewModel: SearchMusicViewModel
    @ObservedObject var lyricsViewModel: SelectLyricsViewModel
    @Binding var songData: SelectedSong
    
    
    @State private var selectedTexts: [String] = Array(repeating: "", count: 4)
    
    @State private var startSelectionIndex: Int?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack(spacing: 11){
                
                AsyncImage(url: songData.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .padding(.leading, 35)
                } placeholder: {
                }
                
                
                
                VStack(alignment: .leading){
                    Text(songData.name)
                        .foregroundColor(Color(hex: 0x111111))
                        .font(.system(size: 14.48276))
                    Text("노래 · " + songData.artist)
                        .foregroundColor(Color(hex: 0x767676))
                        .font(.system(size: 14.48276))
                }
                Spacer()
            }
            
            
            ScrollView {
                VStack(alignment: .leading){
                    ForEach(lyricsViewModel.lyrics.indices, id: \.self) { index in
                        
                        let text = lyricsViewModel.removeCharactersInsideBrackets(from: lyricsViewModel.lyrics[index])
                        
                        Button(action: {
                            if let start = startSelectionIndex {
                                let startIndex = min(start, index)
                                let endIndex = max(start, index)
                                let range = startIndex...endIndex
                                
                                
                                selectedTexts = lyricsViewModel.lyrics[range].map { $0 }
                                startSelectionIndex = nil
                            } else {
                                if selectedTexts.contains(text) {
                                    selectedTexts.removeAll { $0 == text }
                                } else {
                                    selectedTexts.append(text)
                                    startSelectionIndex = index
                                }
                            }
                        }) {
                            HStack(alignment: .top) {
                                    Text(text)
                                        .padding()
                                        .font(.system(size: 34, weight: .medium))
                                        .lineSpacing(10)
                                        .foregroundColor(selectedTexts.contains(text) ? Color.white : Color.white)
                                        .multilineTextAlignment(.leading)

                                    
                                }
                                .frame(maxWidth: 349, alignment : .leading) /
                                .background(selectedTexts.contains(text) ? Color.gray.opacity(0.75) : Color.clear)
                                .cornerRadius(10)

                            
                        }
                    }
                }
                .padding(.leading, 28)
                .onAppear {
                    lyricsViewModel.fetchHTMLParsingResult(songData)
                }
            }
            
            NavigationLink(destination: EditCardView(viewModel: EditCardViewModel(card: Card(albumArtUIImage:  UIImage(data: try! Data(contentsOf: songData.imageUrl!))!, title: songData.name, singer: songData.artist, lyrics: selectedLyrics, cardColor: .gray)))){
                ZStack{
                    Rectangle()
                        .frame(width: 350, height: 60)
                        .cornerRadius(30)
                        .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                    Text("가사 선택 완료")
                        .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                        .font(.system(size: 20, weight: .medium))
                }
            }
            .padding(.top, 33)
        }
        .background(
            Image(uiImage: UIImage(data: try! Data(contentsOf: songData.imageUrl!))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 20, opaque: false)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        
    }
    
    
    
    var selectedLyrics: String {
        let selectedTextsFiltered = selectedTexts.prefix(4).filter { !$0.isEmpty }
        return selectedTextsFiltered.joined(separator: "\n")
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
