//
//  Copyright © 2020 Damian Rzeszot. All rights reserved.
//

import Foundation
import Cache

class AnimalsService {

    // MARK: -

    struct Success: Decodable {
        struct Animal: Decodable {
            enum Gender: String, Decodable {
                case male = "gender-male"
                case female = "gender-female"
                case unknown = "gender-unknown"
            }

            let id: String
            let name: String
            let breed: String?
            let gender: Gender
            let content: String
        }
        let animals: [Animal]
    }

    enum Failure: Error {
        case error(Error)
        case unknown
    }

    typealias Output = Result<Success, Failure>

    // MARK: -

    let url: URL
    let session: URLSession
    let cache: Cache<URL, Success>?

    init(url: URL, session: URLSession = .shared, cache: Cache<URL, Success>? = nil) {
        self.url = url
        self.session = session
        self.cache = cache
    }

    // MARK: -

    func load() -> Success? {
        cache?[url]
    }

    // MARK: -

    func fetch(completion: @escaping (Output) -> Void) {
        let complete = DispatchQueue.main.wrap(completion)
        let request = URLRequest(url: url)

        print("Filters | fetch \(url)")

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let decoder = JSONDecoder()
                do {
                    switch response.statusCode {
                    case 200: // OK
                        let success = try decoder.decode(Success.self, from: data)
                        self.cache?[self.url] = success
                        complete(.success(success))
                    default:
                        complete(.failure(.unknown))
                    }
                } catch {
                    complete(.failure(.error(error)))
                }
            } else if let error = error {
                complete(.failure(.error(error)))
            } else {
                complete(.failure(.unknown))
            }
        }

        task.resume()
    }

}
