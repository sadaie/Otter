// (c) 2019 Sadaie Matsudaira.
// This software licensed under the MIT License.
// See LICENSE file in the project root for full license information.
//

public final class Configuration {
    internal let urlSessionConfiguration: URLSessionConfiguration
    internal let requestInspector: (URLRequest) throws -> URLRequest

    public static var `default`: Configuration {
        return Configuration(urlSessionConfiguration: .default, requestInspector: { $0 })
    }

    public init(urlSessionConfiguration: URLSessionConfiguration, requestInspector: @escaping (URLRequest) throws -> URLRequest) {
        self.urlSessionConfiguration = urlSessionConfiguration
        self.requestInspector = requestInspector
    }
}
