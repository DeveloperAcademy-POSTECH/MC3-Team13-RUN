//
//  SplashView.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/31.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var yOffset: CGFloat = -40
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        if isActive {
            ArchiveCardChipView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        } else {
            ZStack {
                Color.gray04Color.ignoresSafeArea()
                
                VStack {
                    
                    Image("searchPlaceholder")
                        .offset(x: 0, y: yOffset)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.yOffset = -45
                            }
                        }
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

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
