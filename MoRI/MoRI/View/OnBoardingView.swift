//
//  OnBoardingView.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/08/02.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var isViewed: Bool
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack{
            HStack{
                Image("searchPlaceholder")
                    .resizable()
                    .frame(width: 199.36, height: 69.93)
                    .tint(.primaryColor)
                    .foregroundColor(.primaryColor)
            }
            .padding(.bottom, 22.04)
            Text("좋아하는 가사를 기록하고 간직할\n나만의 음악 카드를 만들어보세요")
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .foregroundColor(.gray01Color)
                .font(.custom(FontsManager.Pretendard.medium, size: 18))
                .padding(.bottom, 47.9)
            ZStack{
                Image("card03")
                    .resizable()
                    .frame(width: 187.14, height: 313.86)
                    .rotationEffect(.degrees(-15))
                Image("card02")
                    .resizable()
                    .frame(width: 189.06, height: 317.08)
                Image("card01")
                    .resizable()
                    .frame(width: 183.98, height: 308.08)
                    .rotationEffect(.degrees(15))
            }
            .padding(.bottom, 69.39)
            Button(action: {
                UserDefaults.standard.set(true, forKey: "MORIFirst")
                isViewed.toggle()
            }){
                ZStack{
                    Rectangle()
                        .frame(width: 350, height: 60)
                        .foregroundColor(.primaryColor)
                        .cornerRadius(30)
                    Text("시작하기")
                        .foregroundColor(.gray04Color)
                        .font(.custom(FontsManager.Pretendard.medium, size: 20))
                }
            }
        }
        .scaleEffect(screenWidth/393)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray04Color)
    }
    
    func chooseSize() {
        
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(isViewed: .constant(false))
    }
}
