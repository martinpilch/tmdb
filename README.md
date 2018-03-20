## To compile
Simply run `carthage update --platform ios` in root of the project and you're ready to compile the app

## The idea
Implement example iOS app to demonstrate how to write simple yet robust code that is testable and maintainable. 
I decided to implement something related to movies thus I chose The Movie DB API. THe features are:
- list first page of Popular movies
- after selecting one of the titles the application navigates the user to the detail page
- after pressing the “Watch Trailer” button the application displays a full screen movie player and starts the playback using XCDYoutubeKit
- it handles Offline mode
- user can search movies locally

## The solution
The idea was to write clean, readable and well tested code. I tried to use dependency injection every where, covered almost all the codebase with tests and hopefully created solution with minimum bugs.

To work with frameworks I use Carthage because of it's faster builds.

The app consists of two screens, `Popular` and `Movie`. Every screen consists of following components:

### Service
The service object is performing endpoint calls, fetching and parsing of the response. It's communicating with it's caller through closures.

### Controller
Controller object is making service calls and handling of the request state. It's commnunicating through delegate with view controller.

### View Controller
View controller is the "hub" of the screen. It's using controller to get data, the view configurator to correctly configure UI elements and handler to populate tableView with data. The idea was to keep view controller as small as possible to avoid Massive-View-Controller antipattern.

### View Configurator
Initialize UI elements of the screen and updates them based on the state.

### Table View Handler
Populates tableView with data and handles user actions.

## Tests
I tried to cover all the codebase with tests therefore I use dependency injection heavily. I had to create custom Mocks using URLProtocol to mock Alamofire responses.

## Searching
I implemented searching functionality but used the native UISearchController because it works on all devices and iOS versions correctly.

## Offline mode
I used Reachability framework to check for offline state and eventually display error. When app goes online again it reloads data.
PLEASE NOTE it might not work correctly on iOS simulator.

## Things TODO
- Use RxSwift or BrightFutures framework to make async calls handling easier
- Use some kind of unidirectional data flow e.g. ReSwift
- Implement /configuration call to get supported poster sizes
- Implement specific UI for iPad using split controller
- Tweak youtube player to work correctly on iPhone X
- Implement pagination
