import UITestsFoundation
import XCTest

class MySitesScreen: BaseScreen {
    init() {
        let blogsTable = XCUIApplication().tables["Blogs"]

        super.init(element: blogsTable)
    }

    static func isLoaded() -> Bool {
        return XCUIApplication().tables["Blogs"].exists
    }

    @discardableResult
    func switchToSite(withTitle title: String) -> MySiteScreen {
        XCUIApplication().cells[title].tap()
        return MySiteScreen()
    }
}
