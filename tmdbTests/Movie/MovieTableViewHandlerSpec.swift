import Quick
import Nimble

@testable import tmdb

class MovieTableViewHandlerSpec: QuickSpec {
    override func spec() {

        var delegate: MockMovieTableViewHandlerDelegate!
        var handler: MovieTableViewHandler!
        var tableView: UITableView!
        var item: Movie!

        describe("MovieTableViewHandler") {

            beforeEach {
                delegate = MockMovieTableViewHandlerDelegate()
                handler = MovieTableViewHandler()
                tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
                item = Movie.fixture()

                handler.delegate = delegate
                handler.reload(tableView: tableView, with: item)
            }

            context("on UITableViewDatasource function tableView(_, numberOfRowsInSection:)") {

                it("returns correct number of rows") {
                    expect(tableView.numberOfRows(inSection: 0)) == 2
                }
            }

            context("on UITableViewDatasource function tableView(_, cellForRowAt:)") {

                context("title cell") {

                    it("populates cell with correct viewmodel") {
                        let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                        expect(cell.movie) == item
                    }

                    it("populates cell's titleLabel with correct text") {
                        let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                        expect(cell.titleLabel.text) == item.title
                    }

                    context("trailer button") {

                        it("sets loading to true by default, hides text and disable") {
                            let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                            expect(cell.trailerButton.isLoading) == true
                            expect(cell.trailerButton.isEnabled) == false
                            expect(cell.trailerButton.title(for: .normal)) == ""
                        }

                        it("sets loading to false, shows text and enables on correct response") {
                            handler.reload(tableView: tableView, isLoadingTrailer: false, videoAvailable: true)

                            let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                            expect(cell.trailerButton.isLoading) == false
                            expect(cell.trailerButton.isEnabled) == true
                            expect(cell.trailerButton.title(for: .normal)) == NSLocalizedString("Watch Trailer", comment: "")
                        }

                        it("sets loading to false, shows text and disables on missing video") {
                            handler.reload(tableView: tableView, isLoadingTrailer: false, videoAvailable: false)

                            let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                            expect(cell.trailerButton.isLoading) == false
                            expect(cell.trailerButton.isEnabled) == false
                            expect(cell.trailerButton.title(for: .normal)) == NSLocalizedString("Watch Trailer", comment: "")
                        }
                    }
                }

                context("info cell") {
                    
                    it("populates cell with correct viewmodel") {
                        let cell: MovieInfoTableViewCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MovieInfoTableViewCell
                        expect(cell.viewModel) == item
                    }

                    it("populates cell's genresLabel with correct text") {
                        let cell: MovieInfoTableViewCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MovieInfoTableViewCell
                        let expectedGenres = item.genres.map { $0.name }.joined(separator: ", ")
                        expect(cell.genresLabel.text) == expectedGenres
                    }

                    it("populates cell's overviewLabel with correct text") {
                        let cell: MovieInfoTableViewCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MovieInfoTableViewCell
                        expect(cell.overviewLabel.text) == item.overview
                    }

                    it("populates cell's dateLabel with correct text") {
                        let cell: MovieInfoTableViewCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MovieInfoTableViewCell
                        let expectedDate = DateFormatter.customDateOnly.string(from: item.releaseDate)
                        expect(cell.dateLabel.text) == expectedDate
                    }
                }
            }

            context("on Watch trailer tap") {

                it("calls delegate and sets correct video") {
                    let expectedVideo = Video.fixture()
                    handler.reload(tableView: tableView, isLoadingTrailer: false, videoAvailable: true, trailerVideo: expectedVideo)

                    let cell: MovieTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieTitleTableViewCell
                    cell.trailerButton.sendActions(for: .touchUpInside)
                    expect(delegate.trailerVideo).toEventually(equal(expectedVideo))
                }
            }
        }
    }
}
