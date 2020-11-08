//
//  AuthorizationViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 07.10.2020.
//

import UIKit
import AVFoundation
import Firebase
import Kingfisher

class AuthorizationViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: - IB Outlet
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logoAppImageView: UIImageView!
    
    @IBOutlet var goToLoginStackViewButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var cornerRadiusRegisterLabel: [UIButton]!
    
    @IBOutlet var wanringLabel: UILabel!
    
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var registerStackView: UIStackView!
    
    // MARK: - Let & Var
    private let segueIdentifire = "goLogin"
    private var ref: DatabaseReference!
    
    var hidenloginStackView: Bool!
    var hidenRegisterStackView: Bool!
    
    private var avPlayer: AVPlayer!
    private var avPlayerLayer: AVPlayerLayer!
    private var paused: Bool = false
    
    private let transition = CircularTransiton()
 
    deinit {
        print("Hello")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
    
        wanringLabel.alpha = 0
        loginStackView.isHidden = hidenloginStackView
        registerStackView.isHidden = hidenRegisterStackView
        
        configLayer()
        avPlayerConfiguration()
        authFireBase()
    }
    
    override func viewWillLayoutSubviews() {
        logoAppImageView.layer.cornerRadius = logoAppImageView.frame.width / 2
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
    
    // MARK: - IB Actions
    @IBAction func loginTapped(_ sender: UIButton) { // логиним пользователя через FireBase
        
        guard let login = loginTextField.text, let password = passwordTextField.text, login != "", password != "" else {
            showAlert(title: "Login or password isn't correct", message: nil)
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.showAlert(title: "Error occured", message: nil)
                return
            }
            
            if user != nil {
                return
            }
            self?.showAlert(title: "No such user", message: nil)
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard let login = loginTextField.text, let password = passwordTextField.text, login != "", password != "" else {
            showAlert(title: "Failed to register", message: nil)
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Minimum 6 characters in password", message: nil)
            return
        }
    
        
        Firebase.Auth.auth().createUser(withEmail: login, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else { return print(error!.localizedDescription) }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
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
        showAlert(title: "The main rule 🍒", message: "Cook deliciously, and we will help you with this")
    }
    
    @IBAction func printAlertRegistrationButton(_ sender: UIButton) {
        
        resetPasswordAlert(title: "Reset password", message: "Enter your E-mail")
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        loginTextField.text = nil
        passwordTextField.text = nil
    }

    // MARK: - Firebase Auth
    func authFireBase() {
        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
            }
        }
    }
    // MARK: - Methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startPoint = logoAppImageView.center
        transition.circleColor = .black
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startPoint = logoAppImageView.center
        transition.circleColor = .clear
        return transition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let NavigationVC = segue.destination as? UINavigationController else { return }
        NavigationVC.transitioningDelegate = self
        NavigationVC.modalPresentationStyle = .custom
    }
}

// MARK: -  Extension
extension AuthorizationViewController: UITextFieldDelegate {
    
    // MARK: - UIText Field Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    // MARK: - UIAlert
    private func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "🍒", style: .destructive)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func resetPasswordAlert(title: String, message: String) {
        let resetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        resetController.addTextField { (textField) in
            textField.placeholder = "E-mail"
        }
        
        let resetPassword = UIAlertAction(title: "Send password", style: .default) { (_) in
            guard let textfield = resetController.textFields?.first, textfield.text != "" else { return }
            Auth.auth().sendPasswordReset(withEmail: textfield.text!)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        resetController.addAction(resetPassword)
        resetController.addAction(cancel)
        present(resetController, animated: true, completion: nil)
    }
    
    // MARK: - AVPlayer Config
    func avPlayerConfiguration() {
        
        // BackGround Video
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
        
        // Blur
        view.backgroundColor = .clear
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = view.bounds
        view.insertSubview(blurredView, at: 1)
    }
    
    // MARK: - CALayer
    func configLayer() {
        
        for label in cornerRadiusRegisterLabel {
            label.layer.cornerRadius = 5
        }
        
        logInButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        goToLoginStackViewButton.layer.borderColor = UIColor.white.cgColor
        goToLoginStackViewButton.layer.cornerRadius = 15
        goToLoginStackViewButton.layer.borderWidth = 1
        forgotPasswordButton.layer.borderColor = UIColor.white.cgColor
        forgotPasswordButton.layer.cornerRadius = 15
        forgotPasswordButton.layer.borderWidth = 1
        logInButton.layer.borderWidth = 0.6
        logInButton.layer.borderColor = UIColor.black.cgColor
    }
}


