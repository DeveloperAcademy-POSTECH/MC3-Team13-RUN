//
//  ContentView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import SwiftUI
import CoreData

//struct ContentView: View {
//
//    var body: some View {
//        ZStack{
//            Rectangle()
//                .foregroundColor(.gray)
//            Text("hello MoRI dev")
//        }
//    }
//}

struct ContentView: View {
    @State private var searchTerm: String = ""
    @FocusState private var isSearchBarFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchTerm)
                .searchable(text: $searchTerm) // searchable 적용
                .focused($isSearchBarFocused) // 포커스 적용
                .padding()
            
            Text("Search Result: \(searchTerm)")
        }
        .onAppear {
            isSearchBarFocused = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
