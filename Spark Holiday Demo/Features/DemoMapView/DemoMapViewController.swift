//
//  IndoorMap.swift
//  Spark Holiday Demo
//
//  Created by Jake Dunahee on 6/9/26.
//

import UIKit

class DemoMapViewController: UIViewController {
    
    let barcodeBtntest: UIButton = {
        let button = UIButton()
        button.setTitle("Barcode Test", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
//    @IBAction
    @objc
    func btntestTapped(_ sender: Any) {
        print("test")
    }
    
    func setupUI() {
        barcodeBtntest.frame = CGRect(x: 50, y: 100, width: 300, height: 50)
        barcodeBtntest.addTarget(self, action: #selector(btntestTapped), for: .touchUpInside)
        view.addSubview(barcodeBtntest)
        
        barcodeBtntest.center = view.center
    }
    
}
