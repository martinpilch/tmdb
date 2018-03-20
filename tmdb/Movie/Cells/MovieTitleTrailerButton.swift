import UIKit

// Simple button subclass to include loading indicator
class MovieTitleTrailerButton: UIButton {
    let loadingView: UIActivityIndicatorView

    var isLoading = false {
        didSet {
            loadingView.isHidden = isLoading == false
            titleLabel?.isHidden = isLoading

            if isLoading {
                loadingView.startAnimating()
            } else {
                loadingView.stopAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(loadingView)

        let constraints = [
            NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
