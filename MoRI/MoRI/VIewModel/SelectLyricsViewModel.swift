//
//  SelectLyricsViewModel.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/19.
//

import Foundation
import SwiftSoup

class SearchLyricsViewModel: ObservableObject {
    @Published var lyrics: [[String]] = []
    
    init() {
        fetchHTMLParsingResult(artist: "", title: "")
    }
    
    // MARK: 해당 url의 HTML 태그를 가져옵니다.
    func fetchHTMLParsingResult(artist: String, title: String) {
        let urlAddress = "https://genius.com/\(artist)-\(title)-lyrics"
        guard let url = URL(string: urlAddress) else {
            return
        }
        
        DispatchQueue.global().async {
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                
                let container = try doc.select(".Lyrics__Container-sc-1ynbvzw-5.Dzxov")
                var lyricsArray = [[String]]()
                
                for element in container.array() {
//                    let brTags = try element.select("br")
//                    if brTags.array().isEmpty {
//                        lyricsArray.append([try element.text()])
//                    } else {
//                        for brTag in brTags.array() {
//                            try brTag.after("\n")
//                        }
//                        let lines = try element.text().components(separatedBy: "\n")
//                        lyricsArray.append(lines)
//                    }
                    let lines = try element.html().replacingOccurrences(of: "<br>", with: "\n")
                    let cleanedText = try SwiftSoup.parse(lines).text()
                    lyricsArray.append([cleanedText])
                }
                
                DispatchQueue.main.async {
                    self.lyrics = lyricsArray
                    print(self.lyrics)
                }
                
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
    }
    
    //MARK: TEXT에서 중괄호 안의 내용들을 삭제합니다.
    func removeCharactersInsideBrackets(from text: String) -> String {
        var result = ""
        var isInBrackets = false

        for char in text {
            if char == "[" {
                isInBrackets = true
            } else if char == "]" {
                isInBrackets = false
            } else if !isInBrackets {
                result.append(char)
            }
        }
        return result
    }
}
