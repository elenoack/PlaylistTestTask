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
    
    private let networkClient = DefaultNetworkClient()
    private var albums = [Album]()
    
    // MARK: - Init
    init() {
        fetchData()
    }
    
    // MARK: - Methods
    func updateAlbums(request: PlaylistMainDTO.GetPlaylist.Request) {
        let filtedAlbums = albums.filter { album in
            album.title.lowercased().contains(
                request.predicate.lowercased()) || album.subtitle.lowercased().contains(request.predicate.lowercased())
        }
        let viewModels: [PlaylistCellViewModel] = filtedAlbums.map {
            return createCellModel(album: .init(request: $0)) }
    }
    
    func getDefaulConfigureCell() {
        let viewModels: [PlaylistCellViewModel] = albums.map {
            return createCellModel(album: .init(request: $0)) }
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
                let request = PlaylistRequestFactory.playlist.urlReques
                let data: PlayListDTO = try await networkClient.perform(request: request)
                albums = data.albums
                let viewModels: [PlaylistCellViewModel] = albums.map {
                    return createCellModel(album: .init(request: $0)) }
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
