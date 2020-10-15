//
//  AuthorizationViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 07.10.2020.
//

import UIKit
import AVFoundation

class AuthorizationViewController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var registerStackView: UIStackView!
    
    @IBOutlet var cornerRadiusRegisterLabel: [UIButton]!
    
    var hidenloginStackView: Bool!
    var hidenRegisterStackView: Bool!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in cornerRadiusRegisterLabel {
            label.layer.cornerRadius = 5
        }
        
        loginStackView.isHidden = hidenloginStackView
        registerStackView.isHidden = hidenRegisterStackView
        
        logInButton.layer.cornerRadius = 10
        
        // MARK: - BackGround Video
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
        
        // MARK: - Blur
        view.backgroundColor = .clear
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = view.bounds
        view.insertSubview(blurredView, at: 1)
    }
    
    // MARK: - Methods
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero, completionHandler: nil)
    }
    
    // MARK: - view Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    // MARK: - View Did Disappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    @IBAction func registerInLoginWindow(_ sender: UIButton) {
        
        loginStackView.isHidden = true
        registerStackView.isHidden = false
    }
    
    @IBAction func loginInRegisterWindow(_ sender: UIButton) {
        
        loginStackView.isHidden = false
        registerStackView.isHidden = true
    }
    @IBAction func termsOfUse(_ sender: UIButton) {
        showAlert(title: "Главное правило 🍒", message: "Готовьте вкусно, а мы в этом поможем")
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        loginTextField.text = nil
        passwordTextField.text = nil
    }
}

    // MARK: - UIText Field Delegate
extension AuthorizationViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
          performSegue(withIdentifier: "goLogin", sender: nil)
        }
        return true
    }
}
    // MARK: - UIAlert
extension AuthorizationViewController {
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
