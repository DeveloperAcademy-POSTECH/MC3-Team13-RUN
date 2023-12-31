//
//  SelectLyricsView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI
import UIKit

struct SelectLyricsView: View {
    @ObservedObject var musicViewModel: SearchMusicViewModel
    @ObservedObject var lyricsViewModel: SelectLyricsViewModel
    @Binding var songData: SelectedSong
    @Binding var pureData: PureSong
    @State private var selectedTextIndices: [Int] = []
    
    
    @State private var startSelectionIndex: Int?
    @State private var lyricsColor: Color = .whiteColor
    
    @Environment(\.dismiss) private var dismiss
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack {
            HStack(spacing: 11){
                
                AsyncImage(url: songData.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .padding(.leading, 35)
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .cornerRadius(4.8)
                }
                
                VStack(alignment: .leading){
                    Text(pureData.name)
                        .font(.custom(FontsManager.Pretendard.medium, size: 14.48276))
                        .foregroundColor(lyricsColor)
                    
                    Text("노래 · " + pureData.artist)
                        .font(.custom(FontsManager.Pretendard.medium, size: 14.48276))
                        .foregroundColor(lyricsColor)
                    
                }
                Spacer()
            }
            .scaleEffect(screenWidth/393)
            
            if lyricsViewModel.lyrics.count == 0 {
                
                VStack{
                    Spacer()
                    
                    Text(lyricsViewModel.isEmpty)
                        .foregroundColor(.white)
                        .font(.system(size: 34, weight: .semibold))
                        .frame(width: 320, height: 78, alignment: .center)
                    
                    Spacer(minLength: 250)
                }
                .scaleEffect(screenWidth/393)
                
            }
                else {
                    ScrollView {
                        VStack(alignment: .leading){
                            ForEach(lyricsViewModel.lyrics.indices, id: \.self) { index in
                                
                                let text = lyricsViewModel.removeCharactersInsideBrackets(from: lyricsViewModel.lyrics[index])
                                
                                Button(action: {
                                    if let start = startSelectionIndex {
                                        let startIndex = min(start, index)
                                        let endIndex = max(start, index)
                                        
                                        if endIndex > startIndex + 3 {
                                            selectedTextIndices = Array(startIndex...startIndex + 3)
                                            startSelectionIndex = nil
                                        } else {
                                            selectedTextIndices = Array(startIndex...endIndex)
                                            startSelectionIndex = nil
                                        }
                                    }
                                    else {
                                        if selectedTextIndices.contains(index) {
                                            selectedTextIndices.removeAll { $0 == index }
                                        } else if selectedTextIndices.count >= 4 {
                                            selectedTextIndices.removeLast()
                                            selectedTextIndices.insert(index, at: 0) // Insert at the beginning
                                        } else {
                                            selectedTextIndices.insert(index, at: selectedTextIndices.endIndex) // Insert at the end
                                            startSelectionIndex = index
                                        }
                                        selectedTextIndices.sort() // Sort the array to maintain the ascending order
                                    }
                                    
                                }) {
                                    HStack(alignment: .top) {
                                        Text(text)
                                            .padding()
                                            .font(.custom(FontsManager.Pretendard.medium, size: 34))
                                            .lineSpacing(10)
                                            .foregroundColor(lyricsColor)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: 349, alignment : .leading)
                                    .background(selectedTextIndices.contains(index) ? Color.gray.opacity(0.75) : Color.clear)
                                    .cornerRadius(10)
                                }
                            }
                            
                            Text("라이센스 소유 및 가사 제공 : Genius")
                                .padding(10)
                        }
                        .padding(.leading, 3)
                        
                    }
                    
                }
                
                NavigationLink(destination: EditCardView(viewModel: EditCardViewModel(card: Card(albumArtUIImage:  UIImage(data: try! Data(contentsOf: songData.imageUrl!))!, title: songData.name, singer: songData.artist, lyrics: selectedLyrics, cardColor: .gray)), pureData: $pureData)){
                    ZStack{
                        Rectangle()
                            .frame(width: 350, height: 60)
                            .cornerRadius(30)
                            .foregroundColor(.gray03Color)
                        Text("가사 선택 완료")
                            .foregroundColor(.primaryColor)
                            .font(.custom(FontsManager.Pretendard.medium, size: 20))
                    }
                }
                .padding(.top, 33)
                .padding(.bottom, 22)
            
        }
        .onAppear {
            lyricsViewModel.fetchHTMLParsingResult(songData)
            
            DispatchQueue.global().async {
                if let imageUrl = songData.imageUrl {
                    do {
                        let imageData = try Data(contentsOf: imageUrl)
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            lyricsColor = chooseLyricsColor(image!)
                        }
                    } catch {
                        print("Error downloading image: \(error)")
                    }
                }
            }
        }
        .background(
            AsyncImage(url: songData.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 20)
            } placeholder : {
                Image(systemName: "music.note")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .cornerRadius(4.8)
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    
    
    var selectedLyrics: String {
        let selectedTextsFiltered = selectedTextIndices.prefix(4).map { lyricsViewModel.lyrics[$0] }
        return selectedTextsFiltered.joined(separator: "\n")
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
            lyricsViewModel.isEmpty = "로딩 중 ..."
            lyricsViewModel.lyrics = []
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
}


extension SelectLyricsView {
    func chooseLyricsColor(_ albumArt: UIImage ) -> Color {
        let averageColor = Color(uiColor: albumArt.averageColor!)
        let r = averageColor.components.r
        let g = averageColor.components.g
        let b = averageColor.components.b
        let cmax = max(r, g, b)
        let cmin = min(r, g, b)
        let lightness = ((cmax+cmin)/2.0)*100
        let lyricsColor = lightness >= 60 ? Color.gray03Color : .white
        return lyricsColor
    }
}
