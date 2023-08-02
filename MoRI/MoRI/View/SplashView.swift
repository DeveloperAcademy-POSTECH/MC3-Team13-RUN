//
//  SplashView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/31.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        if isActive {
            ArchiveCardChipView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        } else {
            ZStack {
                Color.gray04Color.ignoresSafeArea()
                
                VStack {
                    Image("searchPlaceholder").renderingMode(.template)
                        .foregroundColor(.primaryColor)
                        .offset(x: 0, y: -50)
                }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isActive = true
                }
            }
        }
    }
}
