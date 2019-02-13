// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT Lincense.
// See LINCENSE file in the project root for full license information.
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
        dataHandlingQueue: DispatchQueue? = nil,
        dataHandler: ((Data) throws -> UIImage)? = nil,
        transformingQueue: DispatchQueue = .main,
        transform: @escaping (UIImage) throws -> UIImage = { $0 }
    ) -> Promise<Void> where U: URLConvertible {
        if let u = url {
            return otterManager
                .get(
                    for: u,
                    mappingQueue: dataHandlingQueue,
                    mapper: dataHandler
                )
                .then(on: transformingQueue, transform)
                .then(on: .main) { [weak self] image in
                    self?.image = image
                }
        } else {
            self.clearImage()
            return Promise(())
        }
    }
}
