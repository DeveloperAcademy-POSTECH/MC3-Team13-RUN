//
//  SearchMusicViewModel.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation
import Combine
import MusicKit

class SearchMusicViewModel: ObservableObject {
    
    @Published var searchTerm: String = ""
    @Published var songs: [SongList] = [SongList]()
    
    private let limit: Int = 20
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $searchTerm
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.fetchMusic()
            }
    }
    
    private func createRequest() -> MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
        request.limit = limit
        return request
    }
    
    private func fetchMusic() {
        Task {
            // Request permission
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                // Request -> Response
                do {
                    // Assigns songs
                    let request = createRequest()
                    let result = try await request.response()
                    
                    DispatchQueue.main.async {
                        self.songs = result.songs.compactMap({
                            return .init(name: $0.title,
                                         artist: $0.artistName,
                                         imageUrl: $0.artwork?.url(width: 1000,
                                                                   height: 1000))
                        })
                    }
                } catch {
                    print(String(describing: error))
                }
            default:
                break
            }
        }
    }
    
    //MARK: 가수 이름 처리
    func replaceArtistName(in text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\([^\\)]*\\)", options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        var finalResult = ""
        if countOccurrences(of: ",", in: result) >= 2 {
            finalResult = result.replacingOccurrences(of: "&", with: "-")
        } else {
            finalResult = result.replacingOccurrences(of: "&", with: "and")
        }
        let dashResult = finalResult.replacingOccurrences(of: " ", with: "-")
        let removeResult = dashResult.replacingOccurrences(of: "---", with: "-")
        let removeDot = removeResult.replacingOccurrences(of: ".", with: "")
        let Result = removeDot.replacingOccurrences(of: ",", with: "")
        
        return Result
    }
    
    //MARK: 문자열에서 특정 문자의 개수 파악
    func countOccurrences(of character: Character, in text: String) -> Int {
        var count = 0
        for char in text {
            if char == character {
                count += 1
            }
        }
        return count
    }
    
    //MARK: 노래 제목 처리
    func replaceMusicTitle(in text: String) -> String {
        // Square처럼 feat없는 경우 regexPatternFirst
        let regexPatternFirst = "[+*?]"
        let regexPattern = "\\([^()]*\\)"
        
        let regexFirst = try! NSRegularExpression(pattern: regexPatternFirst, options: [])
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        
        let range = NSRange(location: 0, length: text.utf16.count)
        
        let asteriskResultFirst = regexFirst.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        let asteriskResult = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        //MARK: 노래 안에 소괄호 처리함수
        var extractedText = ""
        regex.enumerateMatches(in: text, options: [], range: range) { (match, _, _) in
            if let matchRange = match?.range {
                if let range = Range(matchRange, in: text) {
                    let matchedString = text[range]
                    extractedText.append(String(matchedString))
                }
            }
        }
        extractedText = extractedText.replacingOccurrences(of: " ", with: "-")
        let containsDot = extractedText.contains(".")
        var result = ""
        if containsDot {
            result = removeSuffixAfterKeywords(in: asteriskResult)
            result = result.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            
        } else {
            result = asteriskResultFirst.replacingOccurrences(of: "[()]", with: "", options: .regularExpression)
        }
        
        let andResult = result.replacingOccurrences(of: "&", with: "and")
        result = andResult.replacingOccurrences(of: " ", with: "-")
        
        
        return result
    }
    
    //MARK: 소괄호안에 피처링 정보, 프로듀스 정보 처리
    func removeSuffixAfterKeywords(in text: String) -> String {
        var result = ""
        let keywords = ["(prod.", "(feat.", "\\[feat.", "(ft.", "\\[ft."]
        var removeNext = false
        var keywordFound = false

        for character in text {
            if removeNext {
                if character == " " {
                    removeNext = false
                }
                continue
            }
            result.append(character)
            if !keywordFound {
                for keyword in keywords {
                    if result.hasSuffix(keyword) {
                        removeNext = true
                        keywordFound = true
                        break
                    }
                }
            }
        }
        return result
    }
}
