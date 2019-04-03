// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT License.
// See LICENSE file in the project root for full license information.
//

import Alamofire
import Promises
import UIKit

extension UIImageView {
    public func clearImage() {
        self.image = nil
    }

    public func setImage<U>(
        with url: U?,
        otterManager: OtterManager = .default,
        settingHandler: ((UIImage) throws -> Void)? = nil,
        dataHandlingQueue: DispatchQueue? = nil,
        dataHandler: ((Data) throws -> UIImage)? = nil,
        transformingQueue: DispatchQueue = .main,
        transform: @escaping (UIImage) throws -> UIImage = { $0 }
    ) rethrows -> Promise<Void> where U: URLConvertible {
        if let u = url {
            let settingHandler = settingHandler ?? { [weak self] image in self?.image = image }
            return try otterManager
                .get(
                    for: u,
                    mappingQueue: dataHandlingQueue,
                    mapper: dataHandler
                )
                .then(on: transformingQueue, transform)
                .then(on: .main, settingHandler)
        } else {
            self.clearImage()
            return Promise(())
        }
    }
}
