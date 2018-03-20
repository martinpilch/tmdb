import UIKit
import AlamofireImage

class PopularTableViewCell: UITableViewCell, NibLoadableView {
    @IBOutlet private(set) var posterImageView: UIImageView!
    @IBOutlet private(set) var titleLabel: UILabel!

    private(set) var viewModel: PopularMovie?

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

        titleLabel.text = ""
        viewModel = nil
    }

    private func setup () {
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = .boldSystemFont(ofSize: 18)

        posterImageView.backgroundColor = .gray
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
    }

    func configure(_ viewModel: PopularMovie) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title

        guard let posterUrl = viewModel.posterUrl else { return }
        posterImageView.af_setImage(withURL: posterUrl)
    }
}

