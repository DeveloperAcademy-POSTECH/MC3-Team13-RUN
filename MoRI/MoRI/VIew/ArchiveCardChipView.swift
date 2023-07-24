//
//  ArchiveCardChipView.swift
//  MoRI
//
//  Created by OhSuhyun on 2023/07/20.
//

import SwiftUI

struct ArchiveCardChipView: View {
    @State var songData: SelectedSong
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CardCD.date, ascending: true)]) private var items: FetchedResults<CardCD>
    
    let background = Color(hue: 0, saturation: 0, brightness: 91/100)
    let backgroundArchive = Color(hue: 0, saturation: 0, brightness: 1)
    
    /* 코드 원본 저장 (수정 시 참고 후 삭제 예정)
     // MARK: - CardChip 생성
     var chipShapes: [CardChip]  // 저장된 카드 이미지 "art"
     var detailChipShapes: [CardChip]    // 저장된 카드 이미지 "all"
     var zIndexPreset: [Double]
     var chipNumber = 0 // 저장된 카드의 수
     
     init() {
     chipShapes = [CardChip]()
     detailChipShapes = [CardChip]()
     zIndexPreset = (1...items.count).map({ value in Double(value) / Double(1) })
     .reversed()
     /*
      reversed(): 회전 방향 및 크기 원근감, 적재 순서 반대
      */
     chipNumber = items.count
     }
     */
    
    // MARK: - Card 생성 => 앨범아트카드(CardDetailArt) / 디테일카드(CardDetailView)
    private var cardMark: [CardDetailArt] {
        var shapes = [CardDetailArt]()
        for i in (0..<items.count) {
            shapes.append(
                CardDetailArt(
                    viewModel: CardDetailViewModel(
                        card: Card(
                            albumArtUIImage: UIImage(data: items[i].albumArt!)!,
                            title: items[i].title!,
                            singer: items[i].singer!,
                            lyrics: items[i].lyrics ?? "No Lyrics",
                            cardColor: Color(red: items[i].cardColorR,
                                             green: items[i].cardColorG,
                                             blue: items[i].cardColorB,
                                             opacity: items[i].cardColorA)
                        )
                    )
                )
            )
        }
        return shapes
    }
    
    private var detailCardMark: [CardDetailView] {
        var shapes = [CardDetailView]()
        for i in (0..<items.count) {
            shapes.append(
                CardDetailView(
                    viewModel: CardDetailViewModel(
                        card: Card(
                            albumArtUIImage: UIImage(data: items[i].albumArt!)!,
                            title: items[i].title!,
                            singer: items[i].singer!,
                            lyrics: items[i].lyrics ?? "No Lyrics",
                            cardColor: Color(red: items[i].cardColorR,
                                             green: items[i].cardColorG,
                                             blue: items[i].cardColorB,
                                             opacity: items[i].cardColorA)
                        )
                    )
                )
            )
        }
        return shapes
    }
    
    //    private var chipNumber: Int {
    //        return items.count
    //    }
    
    //    @State private var zIndexPreset: [Double] = [] // zIndexPreset을 State로 선언
    
    // MARK: - 각도, 드래그 여부, 카드 선택 관련 변수
    @State var delta: Double = 0 // 각도 변화
    @State var currentAngle: Double = 0 // 현재 각도
    @State var currentCard: Int = 0 // 현재 선택된 카드
    @State var isDragging = false   // 드래그 여부
    
    @State private var cardSelected = false // 카드 선택 여부
    @State var selectedIndex: Int?   // 선택된 카드 index
    
    
    var body: some View {
        var standardAngle: Double = cardMark.count > 0 ? Double(360 / cardMark.count) : 0  // 단위각도
        let zIndexPreset = items.count > 0 ? (1...items.count).map { value in Double(value) / Double(1) }.reversed() : []
        
        // MARK: - Drag Gesture
        let dragGesture = DragGesture()
            .onChanged{ val in
                isDragging = true
                delta = -val.translation.height  // 높이 위치 값 변화 반영
                
                let tempCurrentCard = -Int(round(Double(currentAngle + delta) / min(standardAngle, 45))) % cardMark.count
                /*
                 현재 위치에 해당하는 카드 계산
                 현재 각도(360 ~ -360) / 단위 각도(-360/칩 개수) 반올림하여 현재 카드 계산
                 ** 단위 각도가 '-'이기 때문에 -Int로 계산
                 
                 cardMark.count = 카드 갯수
                 Double(360 / cardMark.count) = 카드 1개 당 각도 범위 = standardAngle
                 */
                
                // 현재 카드가 음수인 경우 양수로 변환
                withAnimation(.easeInOut(duration: 0.1)) {
                    if tempCurrentCard < 0 {
                        currentCard = tempCurrentCard + cardMark.count
                    } else {
                        currentCard = tempCurrentCard
                    }
                }
            }
            .onEnded { val in   // 드래그가 끝났을 때 과다 회전한 각도 보정
                isDragging = false
                //                if (cardMark.count > 3) {   // 3개 이하일 경우 드래그 결과 미반영
                currentAngle += delta
                currentAngle = Double((Int(currentAngle) % 360)) // 현재 각도를 -360 ~ 360으로 조정
                //                }
            }
        
        
        NavigationStack {
            ZStack {
                background.frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                Image("moriLogo")
                    .padding(.top, 63)
                    .padding(.bottom, 758.21)
                
                NavigationLink(destination: SearchMusicView(songData: $songData)) {
                    ZStack{
                        Rectangle()
                            .frame(width: 350, height: 60)
                            .cornerRadius(30)
                            .foregroundColor(Color(red: 36/225.0, green: 36/225.0, blue: 36/225.0))
                        Text("만들러 가기")
                            .foregroundColor(Color(red: 0.81, green : 0.92, blue: 0))
                            .font(.system(size: 20, weight: .medium))
                    }
                    .padding(.top, 739)
                    .padding(.bottom, 45)
                }
                
                // MARK: - Wheel 형태의 로테이션 애니메이션 효과
                ZStack {
                    // 모은 카드
                    Text("모은 카드")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.top, 17)
                        .padding(.bottom, 545)
                    
                    ForEach(0 ..< cardMark.count) { index in
                        // 0도를 기준으로 절대적인 인덱스 계산
                        
                        // 현재 카드(currentCard)를 중첩레벨(relativeIndex) 기준 0으로 설정 후 순차적으로 중첩레벨 반영
                        let tempRelativeIndex = index - currentCard
                        let relativeIndex = tempRelativeIndex < 0 ? tempRelativeIndex + cardMark.count : tempRelativeIndex
                        
                        // 범위 밖(음수)인 중첩레벨 양수로 보정
                        let tempCorrectedRelativeIndex = relativeIndex + cardMark.count/2
                        let correctedRelativeIndex = tempCorrectedRelativeIndex >= cardMark.count ? tempCorrectedRelativeIndex - cardMark.count : tempCorrectedRelativeIndex
                        
                        let rotationAngle = (standardAngle) * Double(index) + (isDragging ? currentAngle + delta : currentAngle)
                        ZStack (alignment: .top) {
                            cardMark[index]
                            Text("\(index)")    // 테스트용 -> 카드 번호 구분
                                .font(Font.custom("HelveticaNeue-Bold", size: 90))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(0.59)
                        .padding(.bottom, 120) // for "top"
                        .zIndex(zIndexPreset[correctedRelativeIndex])
                        .opacity(   // 출력 부분 범위 설정
                            cardMark.count <= 3 ? 1 :
                                (rotationAngle <= 0 && (Int(rotationAngle) % 360) >= -90) && (Int(rotationAngle) % 360) <= 0
                            || (rotationAngle >= 0 && (Int(rotationAngle) % 360) >= 270 && (Int(rotationAngle) % 360) <= 360) ? 1 : 0
                        )  // 회전된 각도가 90 이상인 경우 투명도 조정
                        /*
                         rotationAngle의 값
                         +: 위로 드래그, -: 아래로 드래그
                         
                         360도 이상 회전일 경우 360도 단위로 계산
                         Int(rotationAngle) % 360
                         
                         A <= rotationAngle <= B
                         A: 후면부, B: 전면부
                         
                         현재 출력 부분
                         +: 270~ 360, -: -90~0
                         */
                        .rotation3DEffect(  // 회전 효과
                            //                                .degrees(rotationAngle),
                            .degrees(cardMark.count > 3 ? rotationAngle : (standardAngle / 4) * Double(index)), // 3개 이하일 경우 회전 효과 제거
                            /*
                             360 / cardMark.count: 카드 1개가 갖는 각도
                             Double(index): 현재 카드의 인덱스
                             Double(360 / cardMark.count) * Double(index): 현재 카드의 회전 각도 = standardAngle * Double(index)
                             currentAngle + delta: 드래그 전 각도(currentAngle)에 드래그 변화량(delta)를 더하여 계산한 현재 회전 각도
                             */
                            axis: (x: 1, y: 0, z: 0),   // 고정 축(기둥)
                            anchor: UnitPoint(x: 0.5, y: 1.0),  // 회전 기준점
                            perspective: 0.5    // 원근감(중심축과의 거리)
                            /*
                             anchor: UnitPoint 값
                             x: x축 기준 반지름(마주보는 카드 간의 간격)과 좌->우 스크롤시 회전 방향 (+: 시계, -: 반시계)
                             y: y축 기준 반지름 (+: 앞, -: 뒤)
                             */
                        )
                        .onTapGesture {
                            selectedIndex = index
                            cardSelected.toggle()
                        }
                    }
                    //                .padding(.bottom, -100)
                    .shadow(radius: 5, x: 12, y: -8)
                    .gesture(dragGesture)
                }
                .frame(width: 350, height: 585, alignment: .center)
                .background(backgroundArchive)
                .cornerRadius(20)
                .padding(.bottom, 23)
                
                // MARK: - Card Detail
                ZStack {
                    if (items.count > 0) {   // 생성된 카드가 없을 경우의 "Thread 1: Fatal error: Index out of range" 발생 방지
                        detailCardMark[selectedIndex ?? 0]
                            .padding(.bottom, 23)
                            .scaleEffect(cardSelected ? 1 : 0)
                            .opacity(cardSelected ? 1.0 : 0.0)
                            .rotation3DEffect(  // 회전 효과
                                Angle.degrees(cardSelected ? 0: 180),
                                axis: (-5,1,0),
                                perspective: 0.3
                            )
                            .animation(Animation.easeInOut(duration: 0.25))  // 표출
                            .onTapGesture() {
                                self.cardSelected = false
                            }
                    }
                    
                    HStack {
                        // 삭제버튼
                        // 공유버튼
                    }
                }
                
                Button(
                    action: {
                        PersistenceController().addItem(viewContext, "https://static.wixstatic.com/media/2bf4f7_3cef257862174c4c893cd4a802fde28f~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/2bf4f7_3cef257862174c4c893cd4a802fde28f~mv2.jpg", "제목", "가수", "2023.00.00", "가사가사가사", Color.blue)
                    }, label: {
                        ZStack{
                            Circle()
                                .frame(width: 100, height: 100)
                            Text("\(items.count)\n\(items.count)")
                                .foregroundColor(.white)
                        }
                    }
                )
                .offset(x: -120, y: -300)
            }
            .ignoresSafeArea()
            .onTapGesture {
                // 다른 곳을 탭하면 선택된 카드 해제
                selectedIndex = nil
            }
        }
    }
}
