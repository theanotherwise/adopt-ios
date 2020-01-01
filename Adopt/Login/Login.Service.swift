//
//  Login.Service.swift
//  Adopt
//
//  Created by Damian Rzeszot on 01/01/2020.
//  Copyright © 2020 Damian Rzeszot. All rights reserved.
//

import Foundation

extension Login {

    class Service {

        // MARK: -

        struct Input {
            let email: String
            let password: String
        }

        // MARK: -

        struct Success: Codable {
            let token: String
        }

        enum Failure: Error {
            case invalid
            case parsing(Error)
            case unknown
        }

        typealias Output = Result<Success, Failure>

        // MARK: -

        func perform(_ input: Input, completion: @escaping (Output) -> Void) {
            var request = URLRequest(url: URL(string: "https://adopt.rzeszot.pro/api/auth/sign_in")!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(["user":["email": input.email, "password": input.password]])
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                print("sign in | done")

                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 400 {
                        completion(.failure(.invalid))
                        return
                    }
                }

                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Success.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(.parsing(error)))
                    }
                } else {
                    completion(.failure(.unknown))
                }
            }

            task.resume()
        }
    }

}
