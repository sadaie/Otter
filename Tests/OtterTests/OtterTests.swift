// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT License.
// See LICENSE file in the project root for full license information.
//

@testable import Otter
import UIKit
import XCTest

class OtterTests: XCTestCase {
    func testGet() {
        let expectation = self.expectation(description: "download card image")

        OtterManager.default.get(for: "https://matsuri-hi.me/card_image.png").then {
            NSLog("\($0)")
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
        imageView.setImage(with: "https://matsuri-hi.me/card_image.png")
        .catch { e in
            XCTFail(e.localizedDescription)
        }
        .always {
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 10.0)
    }
}
