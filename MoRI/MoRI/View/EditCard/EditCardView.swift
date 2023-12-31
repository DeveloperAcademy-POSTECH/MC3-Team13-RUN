//
//  EditCardView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/19.
//

import SwiftUI

struct EditCardView: View {
    @StateObject var viewModel: EditCardViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var pureData: PureSong
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var backButton: some View {
        Button(action: {
            dismiss()
            print(screenWidth)
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
    var body: some View {
        VStack(spacing: 0){
            CardTop(viewModel: viewModel, pureData: $pureData)
            
            ZStack{
                Rectangle()
                    .frame(width: 350, height: 163) .cornerRadius(20)
                    .foregroundColor(viewModel.lyricsContainerColor)
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .frame(width: 314, height: 0.5)
                    .foregroundColor(viewModel.lyricsContainerColor)
                    .blendMode(.screen)
                    .padding(.top, -81)
                Text(viewModel.card.lyrics)
                    .frame(width: 314, alignment: .leading)
                    .foregroundColor(viewModel.lyricsColor)
                    .font(.custom(FontsManager.Pretendard.regular, size: 17))
                    .lineSpacing(15)
                    .lineLimit(4)
            }
            .compositingGroup()
            NavigationLink(destination: CompleteCardView(viewModel: CompleteCardViewModel(card: Card(albumArtUIImage: viewModel.card.albumArtUIImage, title: viewModel.card.title, singer: viewModel.card.singer, lyrics: viewModel.card.lyrics, cardColor: viewModel.card.cardColor)), pureData: $pureData)) {
                
                    ZStack{ Rectangle()
                            .frame(width: 350, height: 60)
                            .cornerRadius(30)
                            .foregroundColor(.gray03Color)
                        Text("색상 선택 완료")
                            .foregroundColor(.primaryColor)
                            .font(.custom(FontsManager.Pretendard.medium, size: 20))
                }
            }
            .padding(.top, 34)
        }
        .scaleEffect(screenWidth < 415 ? 0.96 : screenWidth/393.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image(uiImage:viewModel.card.albumArtUIImage)
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .blur(radius: 20)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

//struct EditCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCardView(viewModel: EditCardViewModel(card: Card(albumArtUIImage: UIImage(named: "test") ?? UIImage(), title: "커다란", singer: "민수", lyrics: "사랑은 보이지 않는 곳에 흔적을 남기지\n사람은 고스란히 느낄 수가 있지\n서로를 향하는 마음이 진심인지\n참 신기하게도 알 수가 있어\nasdasdsad", cardColor: .clear)))
//    }
//}
