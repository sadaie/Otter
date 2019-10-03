// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT License.
// See LICENSE file in the project root for full license information.
//

import Alamofire
import Promises
import UIKit

public enum Error: Swift.Error {
    case imageConversionError(Data?)

    public var localizedDescription: String {
        switch self {
            case let .imageConversionError(d):
                if let d = d {
                    return "The given data cannot convert into an image: \(d)"
                } else {
                    return "The given data is null."
                }
        }
    }
}

public final class OtterManager {
    private final class Adapter: RequestAdapter {
        private let requestInspector: ((URLRequest) throws -> URLRequest)

        init(requestInspector: @escaping ((URLRequest) throws -> URLRequest)) {
            self.requestInspector = requestInspector
        }

        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            return try self.requestInspector(urlRequest)
        }
    }

    private static let dispatchQueueForOtterManager = DispatchQueue(label: "me.matsuri-hi.otter.manager.default", attributes: [.concurrent])
    private static let dispatchQueueForHttpConnection = DispatchQueue(label: "me.matsuri-hi.otter.manager.http", attributes: [.concurrent])

    public static let `default`: OtterManager = OtterManager(configuration: .default)

    private let sessionManager: SessionManager

    public init(configuration: Configuration) {
        let urlSessionConfiguration = configuration.urlSessionConfiguration
        let manager = SessionManager(configuration: urlSessionConfiguration)
        manager.adapter = Adapter(requestInspector: configuration.requestInspector)
        self.sessionManager = manager
    }

    public func get<U>(
        for url: U,
        on dispatchQueue: DispatchQueue? = nil,
        mappingQueue: DispatchQueue? = nil,
        mapper: ((Data) throws -> UIImage)? = nil
    ) rethrows -> Promise<UIImage> where U: URLConvertible {
        let dispatchQueue = dispatchQueue ?? OtterManager.dispatchQueueForHttpConnection
        let mappingQueue = mappingQueue ?? OtterManager.dispatchQueueForHttpConnection
        let mapper = mapper ?? {
            if let image = UIImage(data: $0, scale: UIScreen.main.scale) {
                return image
            } else {
                throw Error.imageConversionError($0)
            }
        }

        return Promise<UIImage>(on: dispatchQueue) { fulfill, reject in
            self.sessionManager.request(url, method: .get)
                .validate(statusCode: 200 ..< 400)
                .responseData(queue: mappingQueue) { response in
                    switch response.result.flatMap(mapper) {
                        case let .success(image):
                            fulfill(image)
                        case let .failure(e):
                            reject(e)
                    }
                }
        }
    }
}
