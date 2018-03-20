import Quick
import Nimble

@testable import tmdb

class PopularTableViewHandlerSpec: QuickSpec {
    override func spec() {

        var delegate: MockPopularTableViewHandlerDelegate!
        var handler: PopularTableViewHandler!
        var tableView: UITableView!
        var items: [PopularMovie]!

        describe("PopularTableViewHandler") {

            beforeEach {
                delegate = MockPopularTableViewHandlerDelegate()
                handler = PopularTableViewHandler()
                tableView = UITableView()
                items = PopularMovieRoot.fixture().results

                handler.delegate = delegate
                handler.reload(tableView: tableView, with: items)
            }

            context("on UITableViewDatasource function tableView(_, numberOfRowsInSection:)") {

                it("returns correct number of rows") {
                    expect(tableView.numberOfRows(inSection: 0)) == items.count
                }
            }

            context("on UITableViewDatasource function tableView(_, cellForRowAt:)") {

                it("populates cell with correct viewmodel") {
                    let cell: PopularTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PopularTableViewCell
                    expect(cell.viewModel) == items[0]
                }

                it("populates cell's titleLabel with correct text") {
                    let cell: PopularTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PopularTableViewCell
                    expect(cell.titleLabel.text) == items[0].title
                }
            }

            context("on UITableViewDatasource function tableView(_, didSelectRowAt:)") {

                it("returns correct number of rows") {
                    handler.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                    expect(delegate.selectedMovie) == items[0]
                }
            }
        }

    }
}

