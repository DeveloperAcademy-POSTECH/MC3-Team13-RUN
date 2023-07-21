//
//  CardTop.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI
//112 224
struct CardTop: View {
    @StateObject var viewModel: EditCardViewModel
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
                Button(action: {print("pick color")}){
                    ZStack{
                        Circle()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        Image("dropper")
                    }
                }
                .padding(.top, 280)
                .padding(.leading, 300)
                VStack{
                    Circle()
                        .frame(width: 30,height: 30)
                        .offset(viewModel.draggedOffset)
                        .foregroundColor(viewModel.card.cardColor)
                    Circle()
                        .frame(width: 15, height: 15)
                        .offset(viewModel.draggedOffset)
                        .opacity(0.4)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    viewModel.draggedOffset = viewModel.accumulatedOffset + gesture.translation
                                    viewModel.repositionDrag()
                                    viewModel.getColorFromImagePixel()
                                }
                                .onEnded { gesture in
                                    viewModel.accumulatedOffset = viewModel.accumulatedOffset + gesture.translation
                                }
                        )
                }
            }
            .compositingGroup()
            ZStack(alignment: .top){
                Rectangle()
                    .frame(width: 350, height: 74)
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .foregroundColor(viewModel.card.cardColor)
                VStack(spacing: 0){
                    Text(viewModel.card.title)
                        .font(.system(size: 34, weight: .medium))
                        .foregroundColor(viewModel.lyricsColor)
                        .frame(height: 34)
                    Text(viewModel.card.singer + "-" + viewModel.card.date)
                        .frame(width: 314, height: 22, alignment: .leading)
                        .font(.system(size: 14, weight: .regular))
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

struct CardTop_Previews: PreviewProvider {
    static var previews: some View {
        CardTop(viewModel: EditCardViewModel(card: Card(albumArtUIImage: UIImage(named: "test") ?? UIImage(), title: "커다란", singer: "민수", lyrics: "사랑은 보이지 않는 곳에 흔적을 남기지\n사람은 고스란히 느낄 수가 있지\n서로를 향하는 마음이 진심인지\n참 신기하게도 알 수가 있어", cardColor: .clear)))
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
