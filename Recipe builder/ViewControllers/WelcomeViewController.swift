//
//  ViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 07.10.2020.
//

import UIKit
import AVFoundation
import Firebase

class WelcomeViewController: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    @IBOutlet var goRegisterButton: UIButton!
    @IBOutlet var goLoginButton: UIButton!
    
    var paused: Bool = false
    
    let segueIdentifire = "goLoginVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goRegisterButton.layer.cornerRadius = 10
        goLoginButton.layer.cornerRadius = 10
        
        let theURL = Bundle.main.url(forResource:"Food", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
//        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//            if user != nil {
//                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
//
//            }
//        }

    }
    
    // MARK: - Player Method
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero, completionHandler: nil)
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    // MARK: - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let authorizationVC = segue.destination as? AuthorizationViewController else { return }
        switch segue.identifier {
        case "goRegister":
            authorizationVC.hidenloginStackView = true
            authorizationVC.hidenRegisterStackView = false
        case "goLoginVC":
            authorizationVC.hidenRegisterStackView = true
            authorizationVC.hidenloginStackView = false
        default: break
        }
    }
}





