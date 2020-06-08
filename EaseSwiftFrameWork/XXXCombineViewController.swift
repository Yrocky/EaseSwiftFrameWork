//
//  XXXCombineViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/3/24.
//  Copyright © 2020 gmzb. All rights reserved.
//

import UIKit
import Combine

class XXXCombineViewController: BaseViewController {

    @Published var allowCommit = false

    deinit {
        print("\(self) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let aLabel = UILabel()
        aLabel.frame = CGRect.init(origin: view.center,
                                   size: CGSize(width: 100, height: 30))
        aLabel.textColor = .orange
        aLabel.textAlignment = .center
        view.addSubview(aLabel)
        
        let aButton = UIButton()
        aButton.setTitleColor(.green, for: .normal)
        aButton.setTitleColor(.red, for: .disabled)
        aButton.setTitle("Commit", for: .normal)
        aButton.frame = CGRect.init(origin: CGPoint(x: 0, y: 100),
                                    size: CGSize(width: 100, height: 40))
        view.addSubview(aButton)
        
        let aToggle = UISwitch()
        aToggle.frame = CGRect.init(origin: CGPoint(x: 100, y: 300),
                                    size: CGSize(width: 50, height: 30))
        view.addSubview(aToggle)
        
        aToggle.publisher(for: .valueChanged)
            .receive(on: DispatchQueue.main)
            .map { ($0 as! UISwitch).isOn }
            .assign(to: \.isEnabled, on: aButton)

        aToggle.publisher(for: .valueChanged)
            .receive(on: DispatchQueue.main)
            .map { ($0 as! UISwitch).isOn ? "ON" : "OFF" }
            .assign(to: \.text, on: aLabel)
        
        aButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .map{ _ in "Taped" }.assign(to: \.text, on: aLabel)
        
        $allowCommit.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: aButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
