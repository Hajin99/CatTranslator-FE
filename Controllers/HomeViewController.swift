//
//  HomeViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/20/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경 뷰에 그라데이션 적용
        view.applyGradient(colors: [
            UIColor(red: 210/255, green: 245/255, blue: 235/255, alpha: 1),  // 연한 민트 (Mint Cream 느낌)
            UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1)   // 연하늘 + 연보라 느낌
    ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            // 2초 후 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigateToLogin()
            }
        }

        private func navigateToLogin() {
            // .transitionFlipFromRight transitionCrossDissolve
            // 스토리보드 ID 기반으로 LoginViewController 호출
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            UIView.transition(with: self.navigationController!.view, duration: 0.6, options: .transitionCrossDissolve, animations: {
                self.navigationController?.pushViewController(loginVC, animated: false)
            })
            
        }

}
