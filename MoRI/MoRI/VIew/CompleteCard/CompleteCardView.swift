//
//  CompleteCardView.swift
//  MoRI
//
//  Created by Jin Sang woo on 2023/07/24.
//

import SwiftUI

struct CompleteCardView: View {
    @StateObject var viewModel: CompleteCardViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShareSheetShowing = false
    @State private var isButtonPressed = false
    @State private var isNavigateToMain = false
    
    @State var songData: SelectedSong = SelectedSong(name: "", artist: "", imageUrl: nil)
    
    
    var body: some View {
        
        
        VStack(spacing: 0){
            
            
            CompleteCardTop(viewModel: viewModel)
            
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
                    .font(.system(size: 17, weight: .medium))
                    .lineSpacing(15)
            }
            .compositingGroup()
            
            
            NavigationStack {
                VStack {
                    if !isButtonPressed {
                        Button(action: {
                            PersistenceController().addItem(viewContext, viewModel.card.albumArtUIImage, viewModel.card.title, viewModel.card.singer, viewModel.card.date, viewModel.card.lyrics, viewModel.card.cardColor)
                            isButtonPressed.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 350, height: 60)
                                    .cornerRadius(30)
                                    .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                                Text("저장하기")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .padding(.top, 33)
                    } else {
                        Button(action: {
                            NavigationUtil.popToRootView()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 350, height: 60)
                                    .cornerRadius(30)
                                    .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                                Text("메인으로 돌아가기")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .padding(.top, 33)
//                        .background(
//                            NavigationLink(destination: ArchiveCardChipView(), isActive: $isNavigateToMain) {
//                                EmptyView()
//                            }
//                        )
                    }
                }
            }
            
            //            Button(action: {
            //                PersistenceController().addItem(viewContext, viewModel.card.albumArtUIImage, viewModel.card.title, viewModel.card.singer, viewModel.card.date, viewModel.card.lyrics, viewModel.card.cardColor)
            //                isButtonPressed = true
            //
            //
            ////                if isNavigateToMain{
            ////                    presentationMode.wrappedValue.dismiss() // 해당 버튼 클릭 시 뷰 닫기 (루트 뷰로 돌아가기)
            ////                }
            //
            //
            //                if isNavigateToMain{
            //                    NavigationLink(destination: MainView()) {
            //                                    EmptyView()
            //                                }
            //
            //                }
            //                isNavigateToMain = true
            //
            //            } ){
            //                ZStack{ Rectangle()
            //                        .frame(width: 350, height: 60)
            //                        .cornerRadius(30)
            //                        .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
            //                    Text(isButtonPressed ? "메인으로 돌아가기" : "저장하기")
            //                        .foregroundColor(.yellow)
            //                        .font(.system(size: 20, weight: .medium))
            //                }
            //            }
            //            .padding(.top, 33)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image(uiImage:viewModel.card.albumArtUIImage).resizable().ignoresSafeArea().scaledToFill().blur(radius: 20))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: shareButton)
    }
    
    var backButton: some View {
        
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
    }
    
    var shareButton: some View {
        Button(action : {
            isShareSheetShowing.toggle()
        }) {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
                .foregroundColor(Color(hex: 0x767676))
        }
        .sheet(isPresented: $isShareSheetShowing) {
            ActivityViewController(activityItems: [viewModel.card.albumArtUIImage])
        }
    }
    
    
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need for update in this case
    }
}



struct CompleteCardView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteCardView(viewModel: CompleteCardViewModel(card: Card(albumArtUIImage: UIImage(named: "test") ?? UIImage(), title: "커다란", singer: "민수", lyrics: "사랑은 보이지 않는 곳에 흔적을 남기지\n사람은 고스란히 느낄 수가 있지\n서로를 향하는 마음이 진심인지\n참 신기하게도 알 수가 있어", cardColor: .clear)))
    }
}

