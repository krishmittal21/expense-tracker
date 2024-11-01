//
//  Authentication.swift
//
//
//  Created by Krish Mittal on 04/04/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

@Observable
@MainActor
class AuthenticationViewModel {
    var currentUserId = ""
    var user: ERUser? = nil
    var name: String  = ""
    var userType: String  = "User"
    var email: String  = ""
    var phoneNumber: String  = "Not Provided"
    var address: String  = "Not Provided"
    var password: String  = ""
    var confirmPassword: String  = ""
    var authenticationState: AuthenticationState = .unauthenticated
    var isValid: Bool  = false
    var errorMessage: String? = ""
    var displayName = ""
    private var handler: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    var cancellables = Set<AnyCancellable>()
    var isLoading: Bool = false
    
    init(){
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
        fetchUser()
    }
    
    public var isSignedIn: Bool{
        return Auth.auth().currentUser != nil
    }
    
}

extension AuthenticationViewModel {
    private func insertUserRecord(id: String) {
        let db = Firestore.firestore()
        
        let userRef = db.collection(ERUserModelName.firestore).document(id)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error checking for user existence: \(error)")
                return
            }
            
            if let document = document, document.exists {
                print("User with ID \(id) already exists. Skipping insertion.")
            } else {
                let newUser = ERUser(
                    address: self.address,
                    dateCreated: ISO8601DateFormatter().string(from: Date()),
                    dateEdited: "",
                    email: self.email,
                    id: id,
                    name: self.name,
                    phoneNumber: self.phoneNumber,
                    userType: "user"
                )
                
                userRef.setData(newUser.asDictionary()) { error in
                    if let error = error {
                        print("Error inserting new user: \(error)")
                    } else {
                        print("New user with ID \(id) successfully inserted.")
                    }
                }
            }
        }
    }
    
    func updateAddress(_ address: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection(ERUserModelName.firestore).document(userId).updateData([ "address": address ])
    }
    
    func updatePhoneNumber(_ phoneNumber: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection(ERUserModelName.firestore).document(userId).updateData([ "phoneNumber": phoneNumber ])
    }
}

extension AuthenticationViewModel {
    func signInAnonymously() async -> Bool {
        do {
            let result = try await Auth.auth().signInAnonymously()
            name = result.user.isAnonymous ? "Anonymous User" : result.user.displayName ?? ""
            email = result.user.email ?? ""
            insertUserRecord(id: currentUserId)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func signInWithEmailPassword() async -> Bool {
        do {
            let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            name = result.user.displayName ?? ""
            email = result.user.email ?? ""
            UserDefaults().set(true, forKey: K.isLoggedIn)
            return true
        }
        catch  {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        
        authenticationState = .authenticating
        
        guard validate() else {
            return false
        }
        
        do  {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            do {
                try await result.user.sendEmailVerification()
                print("Verification email sent successfully!")
            } catch {
                print("Error sending verification email: \(error.localizedDescription)")
            }
            insertUserRecord(id: currentUserId)
            UserDefaults().set(true, forKey: K.isSigningUp)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func passwordReset(){
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection(ERUserModelName.firestore).document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.user = ERUser.asObject(from: data)
                /*
                 (
                     address: data[ERUserModelName.address] as? String ?? "",
                     dateCreated: data[ERUserModelName.dateCreated] as? String ?? "",
                     dateEdited: data[ERUserModelName.dateEdited] as? String ?? "",
                     email: data[ERUserModelName.email] as? String ?? "",
                     id: data[ERUserModelName.id] as? String ?? "",
                     name: data[ERUserModelName.name] as? String ?? "",
                     phoneNumber: data[ERUserModelName.phoneNumber] as? String ?? "",
                     userType: data[ERUserModelName.userType] as? String ?? ""
                 )
                 */
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults().set(false, forKey: K.isLoggedIn)
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func delete() {
        Auth.auth().currentUser?.delete()
    }
    
    func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@(gmail|yahoo|outlook|icloud)\.(com|net|org|edu)$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            errorMessage = "Please enter a valid email address from Google, Yahoo, Outlook, or iCloud."
            return false
        }
        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        guard passwordPredicate.evaluate(with: password) else {
            errorMessage = "Password must be at least 8 characters long and contain at least one letter and one number."
            return false
        }
        
        guard password == confirmPassword else{
            errorMessage = "Passwords Dont Match"
            return false
        }
        
        return true
    }
}

extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase Config")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            
            // Check if user exists in Firestore
            let db = Firestore.firestore()
            let docRef = db.collection(ERUserModelName.firestore).document(currentUserId)
            let docSnapshot = try await docRef.getDocument()
            
            if docSnapshot.exists {
                // User exists, get data from Firestore
                let data = docSnapshot.data()
                phoneNumber = data?[ERUserModelName.phoneNumber] as? String ?? "Not Provided"
                address = data?[ERUserModelName.address] as? String ?? "Not Provided"
                userType = data?[ERUserModelName.userType] as? String ?? "Buyer"
            }
            
            name = firebaseUser.displayName ?? ""
            email = firebaseUser.email ?? ""
            insertUserRecord(id: currentUserId)
            UserDefaults().set(true, forKey: K.isLoggedIn)
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}


extension AuthenticationViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        
                        // Set the user ID
                        currentUserId = result.user.uid
                        
                        // Use provided email or set to the user email from result
                        if let providedEmail = appleIDCredential.email {
                            email = providedEmail
                        } else {
                            email = result.user.email ?? ""
                        }
                        
                        // Use provided name or set to the display name from result
                        if let providedName = appleIDCredential.fullName?.formatted() {
                            name = providedName
                        } else {
                            name = result.user.displayName ?? ""
                        }
                        
                        // Check if user exists in Firestore
                        let db = Firestore.firestore()
                        let docRef = db.collection(ERUserModelName.firestore).document(currentUserId)
                        let docSnapshot = try await docRef.getDocument()
                        
                        if docSnapshot.exists {
                            // User exists, get data from Firestore
                            let data = docSnapshot.data()
                            phoneNumber = data?[ERUserModelName.phoneNumber] as? String ?? "Not Provided"
                            address = data?[ERUserModelName.address] as? String ?? "Not Provided"
                            userType = data?[ERUserModelName.userType] as? String ?? "Buyer"
                        } else {
                            // New user, insert record
                            insertUserRecord(id: currentUserId)
                            UserDefaults().set(true, forKey: K.isLoggedIn)
                        }
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // Do nothing if display name already exists
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.displayName = Auth.auth().currentUser?.displayName ?? ""
            } catch {
                print("Unable to update the user's display name: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                    case .authorized:
                        break
                    case .revoked, .notFound:
                        self.signOut()
                    default:
                        break
                    }
                }
                catch {
                }
            }
        }
    }
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}


private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
