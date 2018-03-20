import UIKit
import Alamofire

class CustomSessionDelegate: Alamofire.SessionDelegate {
    override init() {
        super.init()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.rootViewController = PopularViewController.make()
        window?.makeKeyAndVisible()

        return true
    }
}
