//
//  UserViewModel.swift
//  MVVM+Combine
//
//  Created by Oleg Ten on 17/07/2022.
//

import Foundation
import Combine

class ViewModel {
    
    private let apiService: ServiceAPI
    private let URLApiString: URLApiString
    var usersSubject = PassthroughSubject<[User], Error>()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var users: [User] = []
    
    init(apiService: ServiceAPI,
         URLApiString: URLApiString) {
        self.apiService = apiService
        self.URLApiString = URLApiString
    }
    
    func fetchUsers() {
        
//        apiService.fetchUsers(urlString: URLApiString) { [weak self] (result: Result<[User], Error>) in
//
//            switch result {
//            case .success(let users):
//                self?.usersSubject.send(users)
//
//            case .failure(let error):
//                self?.usersSubject.send(completion: .failure(error))
//            }
//        }
        
        apiService.fetchUsers2(urlString: URLApiString)
            .sink { result in
            switch result {
            case .failure(let error):
//                usersSubject.send(error)
                print(error)
            case .finished:
                break
            }
        } receiveValue: { users in
//            self.users = users
            self.usersSubject.send(users)
            print(users)
        }.store(in: &cancellables)

    }
}
