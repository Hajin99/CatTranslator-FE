//
//  MyPageViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/20/25.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var nicknameLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var btnForLogoutViewController: UIButton!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        guard let url = URL(string: "http://192.168.219.102:8080/users/info") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 저장된 토큰 불러오기 (UserDefaults에 저장x -> TokenManager라는 클래스를 하나 만들어서 저장)
        if let token = TokenManager.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("토큰이 없음")
            return
        }

        // 네트워크 요청
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("오류 발생: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("상태 코드: \(httpResponse.statusCode)")
            
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                let result = json["reslt"] as? [String: Any] {

                                let nickname = result["nickname"] as? String ?? "닉네임 없음"
                                let email = result["email"] as? String ?? "이메일 없음"

                                let joinDate = result["joinedAt"] as? String ?? "가입 날짜 없음"
                                print(json)
                                let formattedDate = joinDate.components(separatedBy: "T").first ?? "날짜 없음"
                                // UI 업데이트는 메인 쓰레드에서
                                DispatchQueue.main.async {
                                    self.nicknameLabel.text = "🐱 \(nickname)"
                                    self.emailLabel.text = "📧 \(email)"
                                    self.dateLabel.text = "가입일: \(formattedDate)"
                                }

                            } else {
                                print("JSON 형식 오류")
                            }
            } catch {
                print("JSON 파싱 실패:", error)
            }
        }.resume()
    }

    
    @IBAction func onLogoutViewControllerBtnClicked(_ sender: UIButton) {
        print("RegisterViewController - onLoginViewController() called / 로그아웃 버튼 클릭!!")
        // 토큰 제거
        TokenManager.deleteToken()
        // 로그아웃 로직이 통과된 후에 ...
        // 1. LoginViewController로 이동하는 버전
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        sceneDelegate.window?.rootViewController = loginVC
//        sceneDelegate.window?.makeKeyAndVisible()
        // 2. 루트 뷰 컨트롤러를 HomeViewController로 이동하는 버전
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        // navigationcontroller로 감싸줘야 함수 쓸 수 있다.
        let nav = UINavigationController(rootViewController: homeVC)

        sceneDelegate.window?.rootViewController = nav
        sceneDelegate.window?.makeKeyAndVisible()

    }
}
