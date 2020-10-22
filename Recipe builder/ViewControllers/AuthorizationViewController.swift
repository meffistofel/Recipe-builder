//
//  AuthorizationViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 07.10.2020.
//

import UIKit
import AVFoundation
import Firebase

class AuthorizationViewController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var wanringLabel: UILabel!
    
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var registerStackView: UIStackView!
    
    @IBOutlet var cornerRadiusRegisterLabel: [UIButton]!
    
    let segueIdentifire = "goLogin"
    var ref: DatabaseReference!
    
    var hidenloginStackView: Bool!
    var hidenRegisterStackView: Bool!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        wanringLabel.alpha = 0
        
        for label in cornerRadiusRegisterLabel {
            label.layer.cornerRadius = 5
        }
        
        loginStackView.isHidden = hidenloginStackView
        registerStackView.isHidden = hidenRegisterStackView
        
        logInButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
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
        
        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTextField.text = ""
        passwordTextField.text = ""
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
    
    @IBAction func loginTapped(_ sender: UIButton) { // логиним пользователя через FireBase
        
        guard let login = loginTextField.text, let password = passwordTextField.text, login != "", password != "" else {
           displayWarningLabel(withText: "Login or password isn't correct")
           return 
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
        }
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
            }
        
    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard let login = loginTextField.text, let password = passwordTextField.text, login != "", password != "" else {
            displayWarningLabel(withText: "Failed to register")
            return
        }
        
        Firebase.Auth.auth().createUser(withEmail: login, password: password) { [weak self](user, error) in
            guard error == nil, user != nil else { return print(error!.localizedDescription) }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }
    
        
    
    func displayWarningLabel(withText text: String) {
        wanringLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.wanringLabel.alpha = 1
        } completion: { [weak self] (complete) in
            self?.wanringLabel.alpha = 0
        }
    }

    @IBAction func termsOfUse(_ sender: UIButton) {
        showAlert(title: "Главное правило 🍒", message: "Готовьте вкусно, а мы в этом поможем")
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        loginTextField.text = nil
        passwordTextField.text = nil
    }
    
    @IBAction func printAlertRegistrationButton(_ sender: UIButton) {
        showAlert(title: "Sooooon 🥩", message: "Function in development")
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
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
