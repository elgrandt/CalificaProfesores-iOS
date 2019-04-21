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
                print("Facebook login error: \(error.localizedDescription)")
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
            print("Failed to get access token")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        firebaseLogin(credential: credential)
    }
    
    // Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Google login error: \(error.localizedDescription)")
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
                print("Firebase login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                self.loading.isHidden = true
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
    }
    
    @IBAction func test(_ sender: Any) {
        login(sender)
    }
}
