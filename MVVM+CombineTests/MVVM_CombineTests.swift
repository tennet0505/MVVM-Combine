//
//  MVVM_CombineTests.swift
//  MVVM+CombineTests
//
//  Created by Oleg Ten on 17/07/2022.
//

import XCTest
import Combine
@testable import MVVM_Combine

class MVVM_CombineTests: XCTestCase {

    var sut: ViewModel!
    var serviceAPI: MockApiService!
    var cancellable = Set<AnyCancellable>()
    var users: [User] = []
    
    override func setUpWithError() throws{
        serviceAPI = MockApiService()
        sut = ViewModel(apiService: serviceAPI, URLApiString: .user)
        sut.usersSubject.sink { _ in
            
        } receiveValue: { [weak self] users in
            self?.users = users
        }.store(in: &cancellable)

        try super.setUpWithError()
    }
    override func tearDownWithError() throws {
        serviceAPI = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testUpdateTableView_onSuccess() {
        //given
        let users: [User] = [User(name: "1222", email: "12@gmail.com"), User(name: "0000", email: "999@gmail.com")]
        serviceAPI.fetchUserResult = .success(users)
        //when
        sut.fetchUsers()
        //then
        XCTAssertEqual(users[0].name, "1222")
    }
    
    func testUpdateTableView_onFailure() {
        //given
        serviceAPI.fetchUserResult = .failure(NSError())
        //when
        sut.fetchUsers()
        //then
        XCTAssertEqual(users.count, 0)
    }
    
}


class MockApiService: ServiceAPI {
    
    var fetchUserResult: (Result<[User], Error>)?
    
    func fetchUsers(urlString: URLApiString, complition: @escaping (Result<[User], Error>) -> ()) {
       
        if let result = fetchUserResult {
          complition(result)
        }
    }
    
}
