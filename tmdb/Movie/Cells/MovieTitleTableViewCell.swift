import UIKit
import AlamofireImage

protocol MovieTitleTableViewCellDelegate: class {
    func cell(_ cell: MovieTitleTableViewCell, watchTrailerFor movie: Movie?)
}

class MovieTitleTableViewCell: UITableViewCell, NibLoadableView {
    @IBOutlet private(set) var posterImageView: UIImageView!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var trailerButton: MovieTitleTrailerButton!

    private(set) var movie: Movie?

    weak var delegate: MovieTitleTableViewCellDelegate?

    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
        reset()
    }

    override func prepareForReuse() {
        reset()
    }

    // MARK: Setup
    private func reset() {
        posterImageView.image = nil
        posterImageView.af_cancelImageRequest()

        trailerButton.isLoading = true
        trailerButton.isEnabled = false
        trailerButton.setTitle("", for: .normal)

        titleLabel.text = ""
        movie = nil
    }

    private func setup () {
        selectionStyle = .none
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = .boldSystemFont(ofSize: 28)

        posterImageView.backgroundColor = .gray
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill

        trailerButton.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        trailerButton.setTitleColor(.black, for: .normal)
    }

    // Configure title and poster
    func configure(_ movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title

        guard let posterUrl = movie.posterUrl else { return }
        posterImageView.af_setImage(withURL: posterUrl)
    }

    // Configure watch trailer button loading state and text
    func configure(isLoadingTrailer: Bool, videoAvailable: Bool) {
        trailerButton.isLoading = isLoadingTrailer
        trailerButton.isEnabled = videoAvailable

        let title = NSLocalizedString("Watch Trailer", comment: "Title for Watch Trailer button")
        trailerButton.setTitle(isLoadingTrailer ? "" : title, for: .normal)
    }

    // MARK: User action
    @IBAction func trailerButtonDidTap() {
        delegate?.cell(self, watchTrailerFor: movie)
    }
}
