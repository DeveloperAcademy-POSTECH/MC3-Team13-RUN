//
//  ArchiveCardChipView.swift
//  MoRI
//
//  Created by OhSuhyun on 2023/07/20.
//

import SwiftUI
import CoreHaptics

struct ArchiveCardChipView: View {

    @State private var isSearchMusicViewActive = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CardCD.date, ascending: true)], animation: .default) private var items: FetchedResults<CardCD>
    
    @State private var isHapticOn = false
    @State private var engine: CHHapticEngine?
    @State private var draggedOffset = CGSize.zero
    @State private var accumulatedOffset = CGSize.zero
    
    let background = Color(hue: 0, saturation: 0, brightness: 91/100)
    let backgroundArchive = Color(hue: 0, saturation: 0, brightness: 1)
    
    // MARK: - 각도, 드래그 여부, 카드 선택 관련 변수
    @State var delta: Double = 0 // 각도 변화
    @State var currentAngle: Double = 0 // 현재 각도
    @State var currentCard: Int = 0 // 현재 선택된 카드
    @State var isDragging = false   // 드래그 여부
    
    @State private var cardSelected = false // 카드 선택 여부
    @State var selectedIndex: Int?   // 선택된 카드 index
    @State private var redrawTrigger = false    // 카드 휠 다시 그리기
    @State private var showingAlert = false
    @State private var isShareSheetShowing = false
    @State private var lastTempCurrentCard = 0
    
    var body: some View {
        var standardAngle: Double = items.count > 0 ? Double(360 / items.count) : 0  // 단위각도
        let zIndexPreset = items.count > 0 ? (1...items.count).map { value in Double(value) / Double(1) }.reversed() : []   // 중첩 레벨
        
        // MARK: - Drag Gesture
        let dragGesture = DragGesture()
            .onChanged{ val in
                isDragging = true
                delta = -val.translation.height  // 높이 위치 값 변화 반영
                
                if !isHapticOn {
                    prepareHaptics()
                    isHapticOn = true
                }
                draggedOffset = accumulatedOffset + val.translation
                
                let tempCurrentCard = -Int(round(Double(currentAngle + delta) / (standardAngle))) % items.count

                
                if tempCurrentCard != lastTempCurrentCard {
                    playHapticFeedback()
                    lastTempCurrentCard = tempCurrentCard
                }
                
                withAnimation(.easeInOut(duration: 0.1)) {  // 현재 카드가 음수인 경우 양수로 변환
                    if tempCurrentCard < 0 {
                        currentCard = tempCurrentCard + items.count
                    } else {
                        currentCard = tempCurrentCard
                    }
                }
                
            }
            .onEnded { val in   // 드래그가 끝났을 때 과다 회전한 각도 보정
                isDragging = false
                currentAngle += delta
                currentAngle = Double((Int(currentAngle) % 360)) // 현재 각도를 -360 ~ 360으로 조정
                accumulatedOffset = accumulatedOffset + val.translation
                stopHapticFeedback()
                isHapticOn = false
            }
        // MARK: - Navigation
        NavigationStack {
            ZStack {
                background.frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                Image("moriLogo")
                    .padding(.top, 63)
                    .padding(.bottom, 758.21)
                
                NavigationLink(destination: SearchMusicView(), isActive: $isSearchMusicViewActive) {
                    EmptyView()
                }
                .hidden()
                
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
                .onTapGesture {
                    isSearchMusicViewActive = true // 버튼을 눌렀을 때 NavigationLink 활성화
                }
                
                // MARK: - Wheel 형태의 로테이션 애니메이션 효과
                ZStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        // 0도를 기준으로 절대적인 인덱스 계산
                        
                        // 현재 카드(currentCard)를 중첩레벨(relativeIndex) 기준 0으로 설정 후 순차적으로 중첩레벨 반영
                        let tempRelativeIndex = items.firstIndex(of: item)! - currentCard
                        let relativeIndex = tempRelativeIndex < 0 ? tempRelativeIndex + items.count : tempRelativeIndex
                        
                        // 범위 밖(음수)인 중첩레벨 양수로 보정
                        let tempCorrectedRelativeIndex = relativeIndex + items.count/2
                        let correctedRelativeIndex = tempCorrectedRelativeIndex >= items.count ? tempCorrectedRelativeIndex - items.count : tempCorrectedRelativeIndex
                        
                        let rotationAngle = (standardAngle) * Double(items.firstIndex(of: item)!) + (isDragging ? currentAngle + delta : currentAngle)
                        ZStack (alignment: .top) {
                            // MARK: - Card 생성 => 앨범아트카드(CardDetailArt)
                            CardDetailArt(viewModel: CardDetailViewModel(
                                card: Card(
                                    /* index
                                    albumArtUIImage: UIImage(data: items[index].albumArt!)!,
                                    title: items[index].title!,
                                    singer: items[index].singer!,
                                    lyrics: items[index].lyrics ?? "No Lyrics",
                                    cardColor: Color(red: items[index].cardColorR,
                                                     green: items[index].cardColorG,
                                                     blue: items[index].cardColorB,
                                                     opacity: items[index].cardColorA)
                                    */
                                    albumArtUIImage: UIImage(data: item.albumArt!)!,
                                    title: item.title!,
                                    singer: item.singer!,
                                    lyrics: item.lyrics ?? "No Lyrics",
                                    cardColor: Color(red: item.cardColorR,
                                                     green: item.cardColorG,
                                                     blue: item.cardColorB,
                                                     opacity: item.cardColorA)
                                )))
//                            // 테스트용 -> 인덱스 확인
//                            Text("\(index)")
//                                .font(Font.custom("HelveticaNeue-Bold", size: 90))
//                                .foregroundColor(.white)
                        }
                        // MARK: - Card 생성 => 앨범아트카드(CardDetailArt) 효과
                        .scaleEffect(0.59)
                        .padding(.bottom, 150) // for "top"
                        .zIndex(zIndexPreset[correctedRelativeIndex])
                        .opacity(   // 회전된 각도에 따른 투명도 조절
                            items.count <= 3 ? 1 :
                                (rotationAngle <= 0 && (Int(rotationAngle) % 360) >= -90) && (Int(rotationAngle) % 360) <= 0
                            || (rotationAngle >= 0 && (Int(rotationAngle) % 360) >= 270 && (Int(rotationAngle) % 360) <= 360) ? 1 : 0
                        )  // 3개 이하일 경우 전부 출력, 3개 초과일 경우 4사분면만 출력
                        .rotation3DEffect(  // 회전 효과
                            .degrees(items.count > 1 ? rotationAngle : Double(Int(rotationAngle) % 90)),
                            axis: (x: 1, y: 0, z: 0),   // 고정 축(기둥)
                            anchor: UnitPoint(x: 0.5, y: 1.0),  // 회전 기준점
                            perspective: 0.5    // 원근감(중심축과의 거리)
                        )
                        .onTapGesture {
                            selectedIndex = index
                            cardSelected = true
                        }
                    }
                    .shadow(radius: 5, x: 8, y: -4)
                    .gesture(dragGesture)
                }
                .frame(width: 350, height: 585, alignment: .center)
                .background(backgroundArchive)
                .cornerRadius(20)
                .contentShape(Rectangle())  // 콘텐츠 표현 가능 영역 제한
                .padding(.bottom, 23)
                .onChange(of: selectedIndex) { newIndex in
                    redrawTrigger.toggle()
                }
                .id(redrawTrigger)
                
                // MARK: - Card 디테일 화면 생성 => 앨범디테일카드(CardDetailView)
                ZStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        if (selectedIndex == index) {   // 해당 인덱스 카드 선택일 경우
                            CardDetailView(viewModel: CardDetailViewModel(
                                card: Card(
                                    albumArtUIImage: UIImage(data: items[index].albumArt!)!,
                                    title: items[index].title!,
                                    singer: items[index].singer!,
                                    lyrics: items[index].lyrics ?? "No Lyrics",
                                    cardColor: Color(red: items[index].cardColorR,
                                                     green: items[index].cardColorG,
                                                     blue: items[index].cardColorB,
                                                     opacity: items[index].cardColorA)
                                )))
                                .padding(.bottom, 23)
                                .onTapGesture() {
                                    self.cardSelected = false
                                    selectedIndex = nil
                                }
                        }
                    }
                }
                // MARK: - Card 디테일 화면 생성 => 앨범디테일카드(CardDetailView) 효과
                .opacity(cardSelected ? 1.0 : 0.0)
                .scaleEffect(cardSelected ? 1 : 0)
                .rotation3DEffect(
                    Angle.degrees(cardSelected ? 0: 180),
                    axis: (-5,1,0),
                    perspective: 0.3
                )
                .animation(Animation.easeInOut(duration: 0.25))
            }
            .ignoresSafeArea()
            .navigationBarItems(
                trailing: HStack (spacing: 0) {
                    if (selectedIndex != nil) {
                        // MARK: - 디테일 화면 삭제 버튼
                        // 삭제버튼
                        Button(action: {
                            showingAlert = true
                        }){
                            Circle()
                                .foregroundColor(Color.white.opacity(0.15))
                                .frame(width: 39, height: 39)
                                .overlay {
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 23, height: 23)
                                        .foregroundColor(.white)
                                }
                        }
                        .alert("정말 카드를 삭제하시겠습니까?", isPresented: $showingAlert) {
                            Button("취소", role: .cancel) {
                                showingAlert = false
                            }
                            Button("삭제", role: .destructive) {
                                PersistenceController().deleteItems(viewContext, items[selectedIndex!])
                                self.cardSelected = false
                                selectedIndex = nil
                                showingAlert = false
                            }
                        }
                        .padding(.trailing, 37-16)
                        // MARK: - 디테일 화면 공유 버튼
                        // 공유버튼
                        Button(action: {
                            isShareSheetShowing.toggle()
                            print("share button onTapped")
                        }) {
                            Circle()
                                .foregroundColor(Color.white.opacity(0.15))
                                .frame(width: 39, height: 39)
                                .overlay {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 23, height: 23)
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.trailing, 20-16)
                        .sheet(isPresented: $isShareSheetShowing) {
                            ActivityViewController(activityItems: [
//                                CardDetailView(viewModel: CardDetailViewModel(
//                                    card: Card(
//                                        albumArtUIImage: UIImage(data: items[selectedIndex!].albumArt!)!,
//                                        title: items[selectedIndex!].title!,
//                                        singer: items[selectedIndex!].singer!,
//                                        lyrics: items[selectedIndex!].lyrics ?? "No Lyrics",
//                                        cardColor: Color(red: items[selectedIndex!].cardColorR,
//                                                         green: items[selectedIndex!].cardColorG,
//                                                         blue: items[selectedIndex!].cardColorB,
//                                                         opacity: items[selectedIndex!].cardColorA)
//                                    )))
                            ])
                        }
                    }
                }
                    .opacity(cardSelected ? 1.0 : 0.0)
                    .scaleEffect(cardSelected ? 1 : 0)
                    .rotation3DEffect(
                        Angle.degrees(cardSelected ? 0: 180),
                        axis: (-5,1,0),
                        perspective: 0.3
                    )
                    .animation(Animation.easeInOut(duration: 0.25))
            )
        }
    }
    
    // MARK: - Haptic 함수
    func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
//            print("Creating engine error: \(error.localizedDescription)")
        }
    }
    
    func playHapticFeedback() {
        guard let engine = engine else { return }
        
        // Define haptic pattern here
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 1.0) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i, duration: 10)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makeAdvancedPlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
//            print("Failed to play pattern \(error.localizedDescription)")
        }
    }
    
    func stopHapticFeedback() {
        guard let engine = engine else { return }
        engine.stop(completionHandler: { (error) in
            if let error = error {
//                print("Stopping haptic engine error: \(error.localizedDescription)")
            }
        })
    }
}
