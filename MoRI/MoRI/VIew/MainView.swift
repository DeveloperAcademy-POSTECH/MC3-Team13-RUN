//
//  MainView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import SwiftUI

struct MainView: View {
    @State var songData: SelectedSong
    var body: some View {
        NavigationStack {
            NavigationLink(destination: SearchMusicView(songData: $songData)) {
                
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
