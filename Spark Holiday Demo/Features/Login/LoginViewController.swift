//
//  Untitled.swift
//  Spark Holiday Demo
//
//  Created by Jake Dunahee on 6/9/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let btnLogin: UIButton
    
    // MARK: - Init
    
    init() {
        btnLogin = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        btnLogin = UIButton()
        super.init(coder: coder)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    func loginTapped() {
        let mapVC = DemoMapViewController()
        navigationController?.present(mapVC, animated: true)
    }
    
}

// MARK: - Private Functions

private extension LoginViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        btnLogin.setTitle("Log In", for: .normal)
        btnLogin.backgroundColor = .primary
        btnLogin.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btnLogin.layer.cornerRadius = 12.0
        btnLogin.center = view.center
        btnLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        view.addSubview(btnLogin)
    }
    
}
