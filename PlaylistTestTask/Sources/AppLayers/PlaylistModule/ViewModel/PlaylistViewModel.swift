//
//  PlaylistViewModel.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

final class PlaylistViewModel {
    
    // MARK: - Properties
    var playlistCellViewModel = [PlaylistCellViewModel]() {
        didSet {
            updateDate?()
        }
    }
    
    var localizedError: NetworkError = .emptyData {
        didSet {
            failData?()
        }
    }
    
    var updateDate: (() -> Void)?
    var failData: (() -> Void)?
    
    private let networkClient: NetworkClient = DefaultNetworkClient()
    private var albums = [Album]()
    
    // MARK: - Init
    init() {
        fetchData()
    }
    
    // MARK: - Methods
    func updateAlbums(request: PlaylistMainDTO.GetPlaylist.Request) {
        var viewModels = [PlaylistCellViewModel]()
        let filtedAlbums = albums.filter { album in
            album.title.lowercased().contains(
                request.predicate.lowercased()) || album.subtitle.lowercased().contains(request.predicate.lowercased())
        }
        filtedAlbums.forEach { viewModels.append(createCellModel(album: .init(request: $0))) }
        playlistCellViewModel = viewModels
    }
    
    func getDefaulConfigureCell() {
        var viewModels = [PlaylistCellViewModel]()
        for album in albums {
            viewModels.append(createCellModel(album: .init(request: album)))
        }
        playlistCellViewModel = viewModels
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PlaylistCellViewModel {
        return playlistCellViewModel[indexPath.row]
    }
    
    func updateTitle(title: String, for index: Int) {
        playlistCellViewModel[index].title = title
    }
    
}

// MARK: - Private
extension PlaylistViewModel {
    
    private func fetchData() {
        Task {
            do {
                var viewModels = [PlaylistCellViewModel]()
                let request = PlaylistRequestFactory.playlist.urlReques
                let data: PlayListDTO = try await networkClient.perform(request: request)
                albums = data.albums
                for album in albums {
                    viewModels.append(createCellModel(album: .init(request: album)))
                }
                playlistCellViewModel = viewModels
            } catch {
                localizedError = error as? NetworkError ?? .unknown
            }
        }
    }
    
    private func createCellModel(album: PlaylistMainDTO.GetPlaylist.ViewModel) -> PlaylistCellViewModel {
        return PlaylistCellViewModel(
            title: album.request.title,
            subtitle: album.request.subtitle,
            image: album.request.image)
    }
}
