//
//  SelectLyricsViewModel.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/19.
//

import Foundation
import SwiftSoup

class SelectLyricsViewModel: ObservableObject {
    @Published var lyrics: [String] = []
    @Published var isLoaded: Bool = false
    
    @Published var isEmpty: String = "로딩중 ..."
    
    init() {
        fetchHTMLParsingResult(SelectedSong(name: "", artist: ""))
    }
    
    // MARK: 해당 url의 HTML 태그를 가져옵니다.
    func fetchHTMLParsingResult(_ selectedSong: SelectedSong) {
        let urlAddress = "https://genius.com/\(selectedSong.artist)-\(selectedSong.name)-lyrics"
        
        guard let url = URL(string: urlAddress) else {
            isEmpty = "가사 준비 중입니다 !"
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.isEmpty = "가사 준비 중입니다 !"
                print("Error loading URL: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let html = try String(data: data, encoding: .utf8)
                    let doc: Document = try SwiftSoup.parse(html ?? "")
                    
                    let container = try doc.select(".Lyrics__Container-sc-1ynbvzw-5.Dzxov")
                    var lyricsText = ""
                    for element in container.array() {
                        let lines = try element.html()
                            .replacingOccurrences(of: "<br>", with: "\n")
                            .replacingOccurrences(of: "<b>", with: "")
                            .replacingOccurrences(of: "</b>", with: "\n")
                            .replacingOccurrences(of: "<i>", with: "")
                            .replacingOccurrences(of: "</i>", with: "\n")
                            .replacingOccurrences(of: "<br>\n<br>", with: "\n")
                        
                        let cleanLines = self?.removeCharactersInsideBrackets(from: lines)
                        
                        lyricsText += cleanLines!
                    }
                    
                    let linesArray = lyricsText.components(separatedBy: ["\n", "."])
                        .filter { !$0.isEmpty }
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    DispatchQueue.main.async {
                        self?.isEmpty = "가사 준비 중입니다 !"
                        self?.lyrics = linesArray
//                        print(self.lyrics)
                    }
                } catch {
                    print("Error parsing HTML: \(error)")
                    self?.isLoaded = true
                    self?.isEmpty = "가사 준비 중입니다 !"
                }

            }
        }
        task.resume()
    }
    
    
    func removeCharactersInsideBrackets(from text: String) -> String {
        var result = ""
        var isInBrackets = false
        
        for char in text {
            if char == "[" || char == "<" {
                isInBrackets = true
            } else if char == "]" || char == ">" {
                isInBrackets = false
            } else if !isInBrackets {
                result.append(char)
            }
        }
        return result
    }
}
