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
    
//    //MARK: 제목과 아티스트 이름 띄워쓰기 처리
//    func replaceSpacesWithDash(in text: String) -> String {
//        let regex = try! NSRegularExpression(pattern: "\\([^\\)]*\\)", options: [])
//        let range = NSRange(location: 0, length: text.utf16.count)
//        let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
//
//        let dashResult = result.replacingOccurrences(of: " ", with: "-")
//
//        if dashResult.last == "-" {
//            return String(dashResult.dropLast())
//        } else {
//            return dashResult
//        }
//    }
    
    //MARK: 가수 이름 처리
    func replaceArtistName(in text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\([^\\)]*\\)", options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        // Step 4: Replace "and" with "&"
        var finalResult = ""
        if countOccurrences(of: ",", in: result) >= 2 {
                finalResult = result.replacingOccurrences(of: "&", with: "-")
        } else {
            finalResult = result.replacingOccurrences(of: "&", with: "and")
        }
        let dashResult = finalResult.replacingOccurrences(of: " ", with: "-")
        let removeResult = dashResult.replacingOccurrences(of: "---", with: "-")
        let Result = removeResult.replacingOccurrences(of: ",", with: "")

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
        let regexPattern = "[+*]"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
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
        
        // Check if '.' exists in extractedText
        let containsDot = extractedText.contains(".")
        
        // Check if '.' exists in extractedText, and remove parentheses in asteriskResult accordingly
        var result = ""
        if containsDot {
            let removeParenthesesPattern = "\\([^()]*\\)"
            result = asteriskResult.replacingOccurrences(of: removeParenthesesPattern, with: "", options: .regularExpression)
        } else {
            result = asteriskResult.replacingOccurrences(of: "[()]", with: "", options: .regularExpression)
        }
        
        result = result.replacingOccurrences(of: " ", with: "-")
        
        return result
    }

}
