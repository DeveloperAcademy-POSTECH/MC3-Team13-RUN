//
//  ArchiveCardChipView.swift
//  MoRI
//
//  Created by OhSuhyun on 2023/07/20.
//

import SwiftUI
import CoreHaptics

struct ArchiveCardChipView: View {
    
    let backgroundArchive = Color(hue: 0, saturation: 0, brightness: 1) // 카드 스택 영역 배경색
    
    // MARK: - 내비게이션 및 데이터 공유(CoreData, ShareSheet)를 위한 변수
    @State private var isSearchMusicViewActive = false  // 내비게이션 실행 여부

    // 코어데이터 연결
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CardCD.date, ascending: true)], animation: .default) private var items: FetchedResults<CardCD>

    @Environment(\.displayScale) var displayScale   // 공유용 크기
    
    // MARK: - 카드 휠 회전을 위한 드래그 변수
    @State var delta: Double = 0 // 각도 변화
    @State var currentAngle: Double = 0 // 현재 각도
    @State var currentCenterCard: Int = 0 // 현재 선택된 카드
    @State var isDragging = false   // 드래그 여부
    
    // MARK: - 카드 회전 시의 햅틱을 위한 변수
    @State private var isHapticOn = false   // 햅틱 여부
    @State private var engine: CHHapticEngine?
    @State private var lastTempCurrentCenterCard = 0  // 직전에 선택된 카드
    
    // MARK: - 카드 선택 시 디테일 카드 표현을 위한 변수
    @State private var isCardSelected = false // 카드 선택 여부
    @State var selectedIndex: Int?   // 선택된 카드 index
    @State private var redrawTrigger = false    // 카드 휠 다시 그리기
    @State private var isDeleteCard = false // 카드 삭제버튼 선택 여부
    @State private var isShareSheetShowing = false  // 카드 공유버튼 선택 여부
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        var standardAngle: Double = items.count > 0 ? Double(360 / items.count) : 0  // 카드 1장 당의 단위각도
        let zIndexPreset = items.count > 0 ? (1...items.count).map { value in Double(value) / Double(1) }.reversed() : []   // 중첩 레벨
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let scaleWidth = screenWidth / 390
        let scaleHeight = screenHeight / 844
        
        // MARK: - Drag Gesture
        let dragGesture = DragGesture()
            // 드래그 발생 시 현재 선택된 카드 계산 및 햅틱 발생
            .onChanged { val in
                isDragging = true
                delta = -val.translation.height  // 높이 위치 값 변화 반영
                
                if !isHapticOn {
                    prepareHaptics()
                    isHapticOn = true
                }
                
                let tempCurrentCenterCard = -Int(round(Double(currentAngle + delta) / (standardAngle))) % items.count // 현재 회전 각도로 현재 선택된 카드 index 계산
                
                // 현재 선택된 카드의 변경 시 햅틱 발생
                if tempCurrentCenterCard != lastTempCurrentCenterCard {
                    playHapticFeedback()
                    lastTempCurrentCenterCard = tempCurrentCenterCard
                }
                
                // 현재 카드가 음수인 경우 양수로 변환
                if tempCurrentCenterCard < 0 {
                    currentCenterCard = tempCurrentCenterCard + items.count
                } else {
                    currentCenterCard = tempCurrentCenterCard
                }
            }
            // 드래그가 끝났을 때 과다 회전한 각도 보정
            .onEnded { val in
                isDragging = false
                currentAngle += delta   // 현재 각도에 각도 변화량 반영
                currentAngle = Double((Int(currentAngle) % 360)) // 현재 각도 보정 (-360~360)
                stopHapticFeedback()
                isHapticOn = false
            }
        
        // MARK: - Navigation
        NavigationStack {
            ZStack {
                Color.gray02Color.ignoresSafeArea()
                
                // 화면 상단의 로고 영역
                HStack {
                    Image("moriLogo")
                        .padding(.top, 6 * scaleHeight)
                        .padding(.bottom, 7.21 * scaleHeight)
                }
                .padding(EdgeInsets(top: 65 * scaleHeight, leading: 0, bottom: 743 * scaleHeight, trailing: 0))
                
                NavigationLink(destination: SearchMusicView(), isActive: $isSearchMusicViewActive) {
                    EmptyView()
                }
                
                // 화면 하단의 내비게이션 버튼 영역
                ZStack{
                    Rectangle()
                        .frame(width: 350, height: 60)
                        .cornerRadius(30)
                        .foregroundColor(.gray03Color)
                    Text("만들러 가기")
                        .foregroundColor(.primaryColor)
                        .font(.custom(FontsManager.Pretendard.medium, size: 20))
                }
                .padding(.top, 739 * scaleHeight)
                .padding(.bottom, 45 * scaleHeight)
                .onTapGesture {
                    isSearchMusicViewActive = true // 버튼을 눌렀을 때 NavigationLink 활성화
                }
                
                // MARK: - Wheel 형태의 로테이션 애니메이션 효과
                ZStack {
                    // 카드가 없을 경우 플레이스 홀더 배치
                    if items.count < 1 {
                        Text("저장된 카드가 없습니다")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray03Color)
                            .font(.custom(FontsManager.Pretendard.medium, size: 20))
                    }
                    
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        // 0도를 기준으로 절대적인 인덱스 계산
                        
                        // 현재 중심 카드(currentCenterCard)를 중첩레벨(relativeIndex) 기준 0으로 설정 후 순차적으로 중첩레벨 반영
                        let tempRelativeIndex = index - currentCenterCard
                        let relativeIndex = tempRelativeIndex < 0 ? tempRelativeIndex + items.count : tempRelativeIndex // 음수값 보정 (0~items.count)
                        
                        // 현재 중심 카드(currentCenterCard)의 중첩레벨(correctedRelativeIndex)을 중앙 기준으로 설정 후 순차적으로 중첩레벨 반영
                        let tempCorrectedRelativeIndex = relativeIndex + items.count/2
                        let correctedRelativeIndex = tempCorrectedRelativeIndex >= items.count ? tempCorrectedRelativeIndex - items.count : tempCorrectedRelativeIndex  // 카드 개수 초과 범위의 중첩레벨 보정
                        
                        // 현재 카드(index)의 각도에 드래그 값 반영
                        let tempRotationAngle = Double(Int(round((standardAngle) * Double(index) + (isDragging ? currentAngle + delta : currentAngle))) % 360)  // 순차적으로 배치 후 회전 각도 반영
                        let rotationAngle = (tempRotationAngle + 360).truncatingRemainder(dividingBy: 360)  // 회전 각도 보정(0~360)
                          
                        // MARK: - Card 생성 => 앨범아트카드(CardDetailArt)
                        CardDetailArt(viewModel: CardDetailViewModel(card: createCard(for: index)))
                        .scaleEffect(0.59)
                        .padding(.bottom, 150 * ((screenHeight - 82.79) / 761.21)) // 회전 기준점으로부터의 여백
                        .zIndex(zIndexPreset[correctedRelativeIndex])   // 중첩 레벨
                        .opacity(   // 회전된 각도에 따른 투명도 조절
                            items.count <= 3 || (rotationAngle >= 270 && rotationAngle <= 360) ? 1 : 0
                        )  // 3개 이하일 경우 전부 출력, 3개 초과일 경우 4사분면만 출력
                        .rotation3DEffect(  // 회전 효과
                            .degrees(rotationAngle),    // 회전 각도만큼 회전 효과 부여
                            axis: (x: 1, y: 0, z: 0),   // 고정 축(기둥)
                            anchor: UnitPoint(x: 0.5, y: 1.0),  // 회전 기준점
                            perspective: 0.5    // 원근감(중심축과의 거리)
                        )
                        .onTapGesture {
                            selectedIndex = index
                            isCardSelected = true
                        }
                    }
                    .shadow(radius: 5, x: 8, y: -4)
                    .gesture(dragGesture)
                }
                .scaleEffect(screenWidth/393)
                .frame(width: 350, height: ((screenHeight - 82.79) / 761.21) * 570, alignment: .center)
                .background(backgroundArchive)
                .cornerRadius(20)
                .contentShape(Rectangle())  // 콘텐츠 표현 가능 영역 제한
                .padding(.bottom, 23 * scaleHeight)
                // 카드 선택이 발생할 경우 다시 그리기
                .onChange(of: selectedIndex) { newIndex in  // <<help>> newIndex가 불필요함
                    redrawTrigger.toggle()
                }
                .id(redrawTrigger)
                
                // MARK: - Card 디테일 화면 생성 => 앨범디테일카드(CardDetailView)
                ZStack {    // <<help>> ZStack가 불필요함
                    if selectedIndex != nil {   // 선택된 카드가 있을 경우
                        CardDetailView(viewModel: CardDetailViewModel(card: createCard(for: selectedIndex!)))
                            .padding(.bottom, 23)
                            .onTapGesture() {
                                self.isCardSelected = false
                                selectedIndex = nil
                            }
                    }
                }
                .opacity(isCardSelected ? 1.0 : 0.0)
                .scaleEffect(isCardSelected ? 1 : 0)
                .rotation3DEffect(
                    Angle.degrees(isCardSelected ? 0: 180),
                    axis: (-5,1,0), // 회전 기준점
                    perspective: 0.3
                )
                .animation(Animation.easeInOut(duration: 0.25))
                // 아래로 10 이상 드래그할 경우 모달처럼 숨기기
                .gesture(DragGesture().onEnded({ value in
                    if value.translation.height > 10 {
                        self.isCardSelected = false
                        selectedIndex = nil
                    }
                }))
            }
            .ignoresSafeArea()
            .navigationBarItems(
                trailing: HStack (spacing: 0) {
                    if (selectedIndex != nil) { // 선택된 카드가 있을 경우
                        // MARK: - 디테일 화면 삭제 버튼
                        Button(action: {
                            isDeleteCard = true
                        }){
                            Circle()
                                .foregroundColor(Color.white.opacity(0.15))
                                .frame(width: 39, height: 39)
                                .shadow(color: Color(hex: 0x242424, alpha: 0.1), radius: 8, x: 0, y: 8)
                                .overlay {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 21, height: 21)
                                        .foregroundColor(.primaryColor)
                                }
                        }
                        // 삭제 경고창
                        .alert("정말 카드를 삭제하시겠습니까?", isPresented: $isDeleteCard) {
                            Button("취소", role: .cancel) {
                                isDeleteCard = false
                            }
                            Button("삭제", role: .destructive) {
                                PersistenceController().deleteItems(viewContext, items[selectedIndex!])
                                self.isCardSelected = false
                                selectedIndex = nil
                                isDeleteCard = false
                            }
                        }
                        .padding(.trailing, 37-16)
                        // MARK: - 디테일 화면 공유 버튼
                        Button(action: {
                            shareToInstagramStories()
                        }) {
                            Circle()
                                .foregroundColor(Color.white.opacity(0.15))
                                .frame(width: 39, height: 39)
                                .shadow(color: Color(hex: 0x242424, alpha: 0.1), radius: 8, x: 0, y: 8)
                                .overlay {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 21, height: 21)
                                        .foregroundColor(.primaryColor)
                                }
                        }
                        .padding(.trailing, 20-16)
                    }
                }
                // MARK: - 카드 삭제 효과
                    .opacity(isCardSelected ? 1.0 : 0.0)
                    .scaleEffect(isCardSelected ? 1 : 0)
                    .rotation3DEffect(
                        Angle.degrees(isCardSelected ? 0: 180),
                        axis: (-5,1,0),
                        perspective: 0.3
                    )
                    .animation(Animation.easeInOut(duration: 0.25))
            )
        }
    }
    
    // MARK: - 카드 생성
    func createCard(for index: Int?) -> Card {
        return Card(
            albumArtUIImage: UIImage(data: items[index!].albumArt!)!,
            title: items[index!].title!,
            singer: items[index!].singer!,
            lyrics: items[index!].lyrics!,
            cardColor: Color(
                red: items[index!].cardColorR,
                green: items[index!].cardColorG,
                blue: items[index!].cardColorB,
                opacity: items[index!].cardColorA
            )
        )
    }
    
    // MARK: - Share Instagram Stories
    func shareToInstagramStories() {
        
        let returnC = pickColorsFromCardColor(Color(red: items[selectedIndex!].cardColorR, green: items[selectedIndex!].cardColorG, blue: items[selectedIndex!].cardColorB, opacity: items[selectedIndex!].cardColorA))
        
        let stickerImageData = ExtractImage().renderSticker(
            view: ShareView(
                albumArt: UIImage(data: items[selectedIndex!].albumArt!)!,
                singer: items[selectedIndex!].singer!,
                title: items[selectedIndex!].title!,
                cardColor: Color(red: items[selectedIndex!].cardColorR, green: items[selectedIndex!].cardColorG, blue: items[selectedIndex!].cardColorB, opacity: items[selectedIndex!].cardColorA),
                lyrics: items[selectedIndex!].lyrics!,
                lyricsContainerColor: returnC[1],
                lyricsColor: returnC[0]),
            scale: displayScale)?.pngData()
        let blurredImage = ExtractImage().renderBackground(view: ShareBack(albumArt: UIImage(data: items[selectedIndex!].albumArt!)!), scale: displayScale)?.pngData()
        
        
        
        let urlScheme = URL(string: "instagram-stories://share?source_application=\(Bundle.main.bundleIdentifier ?? "")")
        if let urlScheme = urlScheme {
            if UIApplication.shared.canOpenURL(urlScheme) {
                
                var pasteboardItems: [[String : Any]]? = nil
                if let stickerImageData = stickerImageData {
                    pasteboardItems = [
                        [
                            "com.instagram.sharedSticker.stickerImage": stickerImageData,
                            "com.instagram.sharedSticker.backgroundImage": blurredImage as Any
                        ]
                    ]
                }
                
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                ]
                
                if let pasteboardItems = pasteboardItems {
                    UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                }
                
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            } else {
                print("Something went wrong. Maybe Instagram is not installed on this device?")
            }
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

extension ArchiveCardChipView {
    func pickColorsFromCardColor(_ cardColor: Color) -> [Color]{
        let cardColor = cardColor
        let r = cardColor.components.r
        let g = cardColor.components.g
        let b = cardColor.components.b
        let cmax = max(r, g, b)
        let cmin = min(r, g, b)
        let lightness = ((cmax+cmin)/2.0)*100
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        UIColor(cardColor).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        var returnColors = [Color]()
        let lyricsColor = lightness >= 60 ? Color.blackColor : Color.whiteColor
        returnColors.append(lyricsColor)
        
        if( 0.0 <= brightness && brightness < 0.70){
            let lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness+0.1, alpha: 1.0))
            returnColors.append(lyricsContainerColor)
        }
        else if( 0.70 <= brightness && brightness <= 0.85 ){
            let lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness+0.15, alpha: 1.0))
            returnColors.append(lyricsContainerColor)
        }
        else{
            let lyricsContainerColor = Color(UIColor(hue: hue, saturation: saturation, brightness: brightness-0.15, alpha: 1.0))
            returnColors.append(lyricsContainerColor)
        }
        return returnColors
    }
}
