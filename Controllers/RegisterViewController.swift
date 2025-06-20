//
//  RegisterViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/2/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var joinEmailTextField: UITextField!
    @IBOutlet weak var joinNicknameTextField: UITextField!
    @IBOutlet weak var joinPasswordTextField: UITextField!
    @IBOutlet weak var btnForJoin: UIButton!
    
    @IBOutlet weak var btnForLoginViewController: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 상단 네비게이션 바를 숨김 처리.
        self.navigationController?.isNavigationBarHidden = true
        // 배경 뷰에 그라데이션 적용
        view.applyGradient(colors: [
            UIColor(red: 210/255, green: 245/255, blue: 235/255, alpha: 1),  // 연한 민트 (Mint Cream 느낌)
            UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1)   // 연하늘 + 연보라 느낌
    ])
        // 키보드 나타날 때 & 사라질 때 알림 등록
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                                   name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                                   name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // 키보드가 올라올 때 뷰를 올려줌
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrame.height / 2  // 상황에 맞게 조정
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 원위치
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    // join 버튼을 눌렀을 때 실행
    @IBAction func btnForJoin(_ sender: UIButton) {
        
        guard let email = joinEmailTextField.text, let nickname = joinNicknameTextField.text, let password = joinPasswordTextField.text else {
                return
            }

            let joinURL = URL(string: "http://192.168.219.102:8080/users/join")!
            var request = URLRequest(url: joinURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "email": email,
                "nickname": nickname,
                "password": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("요청 실패:", error)
                    return
                }

                guard let data = data else { return }

                do {
                    let decoded = try JSONDecoder().decode(JoinResponse.self, from: data)
                    DispatchQueue.main.async {
                        if decoded.isSuccess {
                            print("회원가입 성공: \(decoded.message)")
                            // 회원가입 성공 후 로그인 탭 화면으로 전환
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("회원가입 실패: \(decoded.message)")
                        }
                    }
                } catch {
                    print("디코딩 에러:", error)
                }
            }
            task.resume()
    }
    
    @IBAction func onLoginViewControllerBtnClicked(_ sender: UIButton) {
        print("RegisterViewController - onLoginViewController() called / 로그인 버튼 클릭!!")
        // RegisterViewController를 pop!
        self.navigationController?.popViewController(animated: true)
    }


}
