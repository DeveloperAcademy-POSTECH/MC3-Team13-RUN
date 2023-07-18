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
                .foregroundColor(.white)
            Text("hello MoRI dev")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
