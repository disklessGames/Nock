
import XCTest
@testable import Nock

class TestMenu: XCTestCase {
    
    let sut = Menu()
    
    func testHasStartButton() {
        
        XCTAssertEqual(sut.titleButton.text, "Nock")
    }
    
    func testThemeButton() {
        
        XCTAssertEqual(sut.themeButton.text, "Theme")
    }
    
    func testScores() {
        
        XCTAssertEqual(sut.scoresButton.text, "Scores")
    }
    
    func testBackground() {
        XCTAssertNotNil(sut.background)
    }
    
    func testSetTheme() {
        sut.setTheme("themePrototype")
        
        XCTAssertEqual(sut.titleButton.fontName, "Chalkduster")
    }
    
}
