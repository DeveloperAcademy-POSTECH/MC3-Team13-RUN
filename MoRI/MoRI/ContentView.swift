//
//  ContentView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.gray)
            Text("hello MoRI dev")
                .font(.custom(FontsManager.Pretendard.semiBold, size: 30))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
