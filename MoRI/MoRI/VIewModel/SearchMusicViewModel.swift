//
//  SearchMusicViewModel.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation
import Combine
import MusicKit

class SearchSongViewModel: ObservableObject {
    
    @Published var searchTerm: String = ""
    @Published var songs: [SongList] = [SongList]()
    
    let limit: Int = 20
    
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
                                         imageUrl: $0.artwork?.url(width: 56,
                                                                   height: 56))
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
    
    
    func replaceSpacesWithDash(in text: String) -> String {
        let result = text.replacingOccurrences(of: " ", with: "-")
        return result
    }
}
