import Foundation
import Reachability

protocol PopularControllerDelegate: class {
    func update(state: Loadable<PopularMovieRoot>)
}

// Class to fetch and filter popular movies data
class PopularController {
    let service: TmdbPopularService
    let reachableManager: InternetReachable?

    private(set) var result: Loadable<PopularMovieRoot> = .notAsked
    var isLoading: Bool { return result == .loading }

    weak var delegate: PopularControllerDelegate?

    init(service: TmdbPopularService, reachableManager: InternetReachable?) {
        self.service = service
        self.reachableManager = reachableManager

        setupReachability()
    }

    // Loading of data
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

    func filter(with text: String?) {
        // Filter only if succesfully loaded data
        switch result {
        case .success(let root):
            let filteredRoot = root.filter(with: text)
            delegate?.update(state: .success(filteredRoot))
        default:
            break
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
            let errorState = Loadable<PopularMovieRoot>.failure(.unreachableError)
            self?.delegate?.update(state: errorState)
        }

        reachableManager?.startListener()
    }
}
