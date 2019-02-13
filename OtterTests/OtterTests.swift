// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT Lincense.
// See LINCENSE file in the project root for full license information.
//

@testable import Otter
import UIKit
import XCTest

class OtterTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGet() {
        let expectation = self.expectation(description: "download card image")

        OtterManager.default.get(for: "https://matsuri-hi.me/card_image.png").then {
            if $0.size.height == 1_024, $0.size.width == 1_024 {
                return // ok
            } else {
                XCTFail("invalid image")
            }
        }
        .catch { e in
            XCTFail(e.localizedDescription)
        }
        .always {
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 10.0)
    }

    func testUIImageViewExtensions() {
        let expectation = self.expectation(description: "download card image into image view")

        let imageView = UIImageView()
        imageView.setImage(with: "https://matsuri-hi.me/card_image.png") { image in
            image
        }
        .catch { e in
            XCTFail(e.localizedDescription)
        }
        .always {
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 10.0)
    }
}
