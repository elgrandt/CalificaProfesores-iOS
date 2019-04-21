//
//  LoginViewController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import SideMenuSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

var currentUser : User?

func showError(error : String, title : String = "Error", self : UIViewController) {
    let alertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(okayAction)
    self.present(alertController, animated: true, completion: nil)
}

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let nextController = "SideMenuController"
    @IBOutlet weak var loading: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Iniciar Sesión"
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        loading.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (FBSDKAccessToken.current() != nil) {
            firebaseFacebookLogin()
        } else if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            GIDSignIn.sharedInstance()?.signIn()
        } else if (Auth.auth().currentUser != nil) {
            currentUser = Auth.auth().currentUser
            loggedSuccessfully()
        } else {
            loading.isHidden = true
        }
    }
    
    func jumpView(next : String, animated : Bool = true) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: next)
        self.present(controller!, animated: animated, completion: nil)
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                showError(error: error.localizedDescription, title: "Login error", self: self)
                return
            }
            self.firebaseFacebookLogin()
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // Facebook
    func firebaseFacebookLogin() {
        guard let accessToken = FBSDKAccessToken.current() else {
            showError(error: "Failed to get access token", title: "Login error", self: self)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        firebaseLogin(credential: credential)
    }
    
    // Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            showError(error: error.localizedDescription, title: "Login error", self: self)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        firebaseLogin(credential: credential)
    }
    
    func firebaseLogin(credential: AuthCredential) {
        // Perform login by calling Firebase APIs
        loading.isHidden = false
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
            self.loading.isHidden = true
            if let error = error {
                showError(error: error.localizedDescription, title: "Login error", self: self)
                return
            }
            currentUser = user?.user
            self.loggedSuccessfully()
        })
    }
    
    func loggedSuccessfully() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.nextController)
        UIApplication.shared.keyWindow?.rootViewController = controller
    }

}

class LoginWithEmailController : UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loading: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect!.height, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @IBAction func login(_ sender: Any) {
        view.endEditing(true)
        loading.isHidden = false
        Auth.auth().signIn(withEmail: emailInput.text!, password: passwordInput.text!) { user, error in
            self.loading.isHidden = true
            if error != nil {
                showError(error: error!.localizedDescription, title: "Login error", self: self)
                return
            } else {
                currentUser = user?.user
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController")
                UIApplication.shared.keyWindow?.rootViewController = controller
            }
        }
    }
}

class RegisterWithEmailController : UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordConfirmInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loading: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect!.height, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @IBAction func register(_ sender: Any) {
        view.endEditing(true)
        if passwordInput.text! == passwordConfirmInput.text {
            loading.isHidden = false
            Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { authResult, error in
                self.loading.isHidden = true
                if let error = error {
                    showError(error: error.localizedDescription, title: "Register error", self: self)
                    return
                }
                let alertController = UIAlertController(title: "Success", message: "User successfully created, now you can sign in.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            showError(error: "Password do not match", title: "Register error", self: self)
        }
    }
}
