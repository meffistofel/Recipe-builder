//
//  ViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 07.10.2020.
//

import UIKit
import AVFoundation
import Firebase

class WelcomeViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: - IB Outlet
    @IBOutlet var goLoginButton: UIButton!
    
    
    // MARK: - Let & Var
    let segueIdentifire = "goLoginVC"
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLayer()
        avPlayerConfiguration()
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let authorizationVC = segue.destination as? AuthorizationViewController else { return }
        authorizationVC.hidenRegisterStackView = true
        authorizationVC.hidenloginStackView = false
    }
}
// MARK: - Extension
extension WelcomeViewController {
    
    // MARK: - AV Player
    func avPlayerConfiguration() {
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
    }
    
    // MARK: - CALayer
    func configLayer() {
        goLoginButton.layer.cornerRadius = 10
        goLoginButton.layer.borderWidth = 1
        goLoginButton.layer.borderColor = UIColor.black.cgColor
    }
}
