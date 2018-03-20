import UIKit
import AlamofireImage

class MovieInfoTableViewCell: UITableViewCell, NibLoadableView {
    static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
    static let infoFont: UIFont = .systemFont(ofSize: 16)

    @IBOutlet private(set) var genresTitleLabel: UILabel!
    @IBOutlet private(set) var genresLabel: UILabel!

    @IBOutlet private(set) var dateTitleLabel: UILabel!
    @IBOutlet private(set) var dateLabel: UILabel!

    @IBOutlet private(set) var overviewTitleLabel: UILabel!
    @IBOutlet private(set) var overviewLabel: UILabel!

    private(set) var viewModel: Movie?

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
        genresLabel.text = ""
        dateLabel.text = ""
        overviewLabel.text = ""

        viewModel = nil
    }

    private func setup () {
        selectionStyle = .none

        genresTitleLabel.font = MovieInfoTableViewCell.titleFont
        genresTitleLabel.text = NSLocalizedString("Genres", comment: "Title for genres section on movie detail screen")

        genresLabel.font = MovieInfoTableViewCell.infoFont
        genresLabel.numberOfLines = 0
        genresLabel.lineBreakMode = .byWordWrapping

        dateTitleLabel.font = MovieInfoTableViewCell.titleFont
        dateTitleLabel.text = NSLocalizedString("Date", comment: "Title for date section on movie detail screen")

        dateLabel.font = MovieInfoTableViewCell.infoFont

        overviewTitleLabel.font = MovieInfoTableViewCell.titleFont
        overviewTitleLabel.text = NSLocalizedString("Overview", comment: "Title for overview section on movie detail screen")

        overviewLabel.font = MovieInfoTableViewCell.infoFont
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
    }

    // Configure the correct texts
    func configure(_ viewModel: Movie) {
        self.viewModel = viewModel

        genresLabel.text = viewModel.genres.map { $0.name }.joined(separator: ", ")
        dateLabel.text = DateFormatter.customDateOnly.string(from: viewModel.releaseDate)
        overviewLabel.text = viewModel.overview
    }
}
