import Foundation

protocol MovieControllerDelegate: class {
    func update(state: Loadable<Movie>)
    func update(videoState: Loadable<Video>)
}

class MovieController {
    let service: TmdbMovieService
    let videoService: TmdbVideoService
    let reachableManager: InternetReachable?
    
    private(set) var result: Loadable<Movie> = .notAsked
    var isLoading: Bool { return result == .loading }

    weak var delegate: MovieControllerDelegate?

    init(service: TmdbMovieService, videoService: TmdbVideoService, reachableManager: InternetReachable?) {
        self.service = service
        self.videoService = videoService
        self.reachableManager = reachableManager

        setupReachability()
    }

    func loadData() {
        guard isLoading == false else { return }
        result = .loading
        
        delegate?.update(state: .loading)
        service.perform { [weak self] result in
            guard let strongSelf = self else { return }

            defer {
                strongSelf.result = result
            }
            
            // Check for connection and return error eventually
            if strongSelf.reachableManager?.isReachable == false {
                strongSelf.delegate?.update(state: .failure(.unreachableError))
                return
            }

            strongSelf.delegate?.update(state: result)
        }
    }

    func loadVideoData() {
        delegate?.update(videoState: .loading)
        videoService.perform { [weak self] result in
            self?.delegate?.update(videoState: result)
        }
    }

    deinit {
        reachableManager?.stopListener()
    }

    // MARK: Reachability

    private func setupReachability() {
        reachableManager?.whenReachable = { [weak self] in
            self?.loadData()
        }

        reachableManager?.whenUnreachable = { [weak self] in
            let errorState = Loadable<Movie>.failure(.unreachableError)
            self?.delegate?.update(state: errorState)
        }

        reachableManager?.startListener()
    }
}

