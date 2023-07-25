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
    
    //MARK: 제목과 아티스트 이름 띄워쓰기 처리
    func replaceSpacesWithDash(in text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\([^\\)]*\\)", options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        let dashResult = result.replacingOccurrences(of: " ", with: "-")
        
        if dashResult.last == "-" {
            return String(dashResult.dropLast())
        } else {
            return dashResult
        }
    }
    
//    //MARK: 가수 뒤의 () 삭제
//    func deleteParentheses(in text: String) -> String {
//        let regex = try! NSRegularExpression(pattern: "\\([^\\)]*\\)", options: [])
//        let range = NSRange(location: 0, length: text.utf16.count)
//        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
//    }
}
