//
//  ApiService.swift
//  MVVM+Combine
//
//  Created by Oleg Ten on 17/07/2022.
//

import Foundation
import Combine

protocol ServiceAPI {
    func fetchUsers(urlString: URLApiString, complition: @escaping (Result<[User], Error>) -> ())
    func fetchUsers2(urlString: URLApiString) -> AnyPublisher<[User], Error>
}

class ApiService: ServiceAPI {
    
    var cancellable = Set<AnyCancellable>()
        
    func fetchUsers(urlString: URLApiString, complition: @escaping (Result<[User], Error>) -> ()) {
        
        let url = URL(string: urlString.fetch)!
        
        URLSession.shared.dataTaskPublisher(for: url)
//            .catch({ error in
//                return Fail(error: error)
//            })
            .map{ $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(let error):
                    complition(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { users in
                complition(.success(users))
            })
            .store(in: &cancellable)
    }
    
    func fetchUsers2(urlString: URLApiString) -> AnyPublisher<[User], Error> {
        
        let url = URL(string: urlString.fetch)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch({ error in
                return Fail(error: error)
            })
            .map{ $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

    }
}


struct User: Decodable {
    var name: String
    var email: String
}

enum URLApiString {
    case user
    case posts
    
    var fetch: String {
        switch self {
        case .user:
            return "https://jsonplaceholder.typicode.com/usersv"
        case .posts:
            return "https://jsonplaceholder.typicode.com/posts"
        }
    }
}
