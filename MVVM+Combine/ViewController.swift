//
//  ViewController.swift
//  MVVM+Combine
//
//  Created by Oleg Ten on 17/07/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel: ViewModel!
    var apiService: ApiService!
    var users: [User] = []
    var cancellable = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        bindViewModel()
        viewModel.fetchUsers()

    }
    
    func setupViewModel() {
        apiService = ApiService()
        viewModel = ViewModel(apiService: apiService, URLApiString: .user)
    }
    
    func bindViewModel() {
        
        viewModel.usersSubject.sink { result in
            switch result {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
        }.store(in: &cancellable)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
    }
}



@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
