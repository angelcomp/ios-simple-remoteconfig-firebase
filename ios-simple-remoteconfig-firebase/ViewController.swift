//
//  ViewController.swift
//  ios-simple-remoteconfig-firebase
//
//  Created by Angelica dos Santos on 11/04/23.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {

    // MARK: private properties
    private let purpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.isHidden = true
        return view
    }()
    
    private let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.isHidden = true
        return view
    }()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    // MARK: override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(purpleView)
        view.addSubview(blueView)
        
        fetchValues()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        purpleView.frame = view.bounds
        blueView.frame = view.bounds
    }
    
    // MARK: private funcs
    
    private func fetchValues() {
        //toggle_ui_background
        
        let defaults: [String: NSObject] = [
            "toggle_ui_background" : false as NSObject
        ]
        
        remoteConfig.setDefaults(defaults)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        let cachedValue = self.remoteConfig.configValue(forKey: "toggle_ui_background").boolValue
        updateUI(showPurpleBackground: cachedValue)
        
        self.remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { status, error in
            if status == .success, error == nil {
                
                self.remoteConfig.activate(completion: { _, error in
                    guard error == nil else { return }
                    
                    let value = self.remoteConfig.configValue(forKey: "toggle_ui_background").boolValue
                    
                    print("value: \(value)")
                    
                    DispatchQueue.main.async {
                        self.updateUI(showPurpleBackground: value)
                    }
                })
            } else {
                print("something went wrong")
            }
        })
    }
    
    private func updateUI(showPurpleBackground: Bool) {
        purpleView.isHidden = !showPurpleBackground
        blueView.isHidden = showPurpleBackground
    }
}

