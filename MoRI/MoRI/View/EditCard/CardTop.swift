//
//  CardTop.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI

struct CardTop: View {
    @StateObject var viewModel: EditCardViewModel
    @State private var dragPointerIsHidden = true
    @Binding var pureData: PureSong
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Image(uiImage: viewModel.card.albumArtUIImage)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .cornerRadius(300, corners: .topRight)
                    .cornerRadius(30, corners: .topLeft)
                Circle()
                    .frame(width: 30, height: 30)
                    .padding(.top, -160)
                    .padding(.leading, -160)
                    .blendMode(.destinationOut)
                Button(action: { dragPointerIsHidden.toggle() }){
                    ZStack{
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                        Image("dropper")
                    }
                }
                .padding(.top, 280)
                .padding(.leading, 300)
                if !dragPointerIsHidden {
                    VStack{
                        Circle()
                            .frame(width: 30,height: 30)
                            .offset(viewModel.draggedOffset)
                            .foregroundColor(viewModel.card.cardColor)
                        ZStack{
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)

                        }
                        .offset(viewModel.draggedOffset)
                    }
                }
            }
            .compositingGroup()
            .gesture(
                DragGesture()
                    .onChanged{ gesture in
                        if(!dragPointerIsHidden){
                            viewModel.draggedOffset = viewModel.accumulatedOffset + gesture.translation
                            viewModel.repositionDrag()
                            viewModel.getColorFromImagePixel()
                        }
                    }
                    .onEnded { gesture in
                        if(!dragPointerIsHidden){
                            viewModel.accumulatedOffset = viewModel.accumulatedOffset + gesture.translation
                        }
                    }
            )
            ZStack(alignment: .top){
                Rectangle()
                    .frame(width: 350, height: 74)
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .foregroundColor(viewModel.card.cardColor)
                VStack(spacing: 0){
                    Text(pureData.name)
                        .frame(width: 314,height: 34, alignment: .center)
                        .font(.custom(FontsManager.Pretendard.medium, size: 34))
                        .foregroundColor(viewModel.lyricsColor)
                        .minimumScaleFactor(0.5)
                    Text(pureData.artist)
                        .frame(width: 314, height: 11.88, alignment: .trailing)
                        .font(.custom(FontsManager.Pretendard.regular, size: 11.88))
                        .foregroundColor(viewModel.lyricsColor)
                        .blendMode(.softLight)
                }
                .padding(.top, 17)
            }.compositingGroup()
        }
        .onAppear{
            viewModel.getColorFromImagePixel()
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
