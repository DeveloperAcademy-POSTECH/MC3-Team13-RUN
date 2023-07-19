//
//  MainView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct MainView: View {
    @State var selectedSong: SelectedSongList
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: SearchMusicView(selectedSong: selectedSong)) {
                
                ZStack{
                    Rectangle()
                        .frame(width: 200, height: 70)
                    
                    Text("임의로 만든 버튼입니둥")
                        .foregroundColor(.black)
                        .font(.title3)
                }
            }
        }
    }
}
