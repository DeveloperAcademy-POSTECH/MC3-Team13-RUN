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
    
    init() {
        fetchHTMLParsingResult(SelectedSong(name: "", artist: ""))
    }
    
    // MARK: 해당 url의 HTML 태그를 가져옵니다.
    func fetchHTMLParsingResult(_ selectedSong: SelectedSong) {
        let urlAddress = "https://genius.com/\(selectedSong.artist)-\(selectedSong.name)-lyrics"
        
        guard let url = URL(string: urlAddress) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
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
                            .replacingOccurrences(of: "<br>", with: " ")
                            .replacingOccurrences(of: "</br>", with: " ")
                            .replacingOccurrences(of: "<b>", with: " ")
                            .replacingOccurrences(of: "</b>", with: " ")
                            .replacingOccurrences(of: "<i>", with: " ")
                            .replacingOccurrences(of: "</i>", with: " ")
                            .replacingOccurrences(of: "\n\n", with: " ")
                        lyricsText += lines
                    }
                    
                    let linesArray = lyricsText.components(separatedBy: "\n")
                    DispatchQueue.main.async {
                        self.lyrics = linesArray
//                        print(self.lyrics)
                    }
                }
                catch {
                    print("Error parsing HTML: \(error)")
                }
            }
        }
        task.resume()
    }

    
    //MARK: TEXT에서 가사가 아닌 부분을 삭제합니다.
    func removeCharactersInsideBrackets(from text: String) -> String {
        var result = ""
        var isInBrackets = false

        for char in text {
            if char == "[" {
                isInBrackets = true
            } else if char == "]" {
                isInBrackets = false
            } else if char == "<" {
                isInBrackets = true
            } else if char == ">" {
                isInBrackets = false
            }
            else if !isInBrackets {
                result.append(char)
            }
        }
        return result
    }
}
