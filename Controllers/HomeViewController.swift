//
//  MainViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/2/25.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    //#FFF8F0
    @IBOutlet weak var analyzeLabel : UILabel!
    @IBOutlet weak var happyLabel : UILabel!
    @IBOutlet weak var foodLabel : UILabel!
    
    var audioPlayer: AVAudioPlayer? // 플레이어 선언
    
    @IBAction func happyButtonTapped(_ sender: UIButton) {
        happySound()
    }
    @IBAction func hungryButtonTapped(_ sender: UIButton) {
        requestSound()
    }
    @IBAction func angryButtonTapped(_ sender: UIButton) {
        angrySound()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        analyzeLabel.layer.cornerRadius = 10
        analyzeLabel.clipsToBounds = true
        happyLabel.layer.cornerRadius = 10
        happyLabel.clipsToBounds = true
        foodLabel.layer.cornerRadius = 10
        foodLabel.clipsToBounds = true
     
        // 상단 네비게이션 바를 숨김 처리.
        self.navigationController?.isNavigationBarHidden = false
        // 배경 뷰에 그라데이션 적용
        view.applyGradient(colors: [
            UIColor(red: 210/255, green: 245/255, blue: 235/255, alpha: 1),  // 연한 민트 (Mint Cream 느낌)
            UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1)   // 연하늘 + 연보라 느낌
    ])
    }
    
    // 평온한 소리
    func happySound() {
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("Font Name: \(name)")
            }
        }

        guard let soundURL = Bundle.main.url(forResource: "happyCat", withExtension: "mp3") else {
            print("사운드 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("사운드 재생 실패: \(error.localizedDescription)")
        }
    }
    
    // 요구하는 소리
    func requestSound() {
        guard let soundURL = Bundle.main.url(forResource: "hungryCat", withExtension: "mp3") else {
            print("사운드 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("사운드 재생 실패: \(error.localizedDescription)")
        }
    }
    
    // 화내는 소리
    func angrySound() {
        guard let soundURL = Bundle.main.url(forResource: "angryCat", withExtension: "mp3") else {
            print("사운드 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("사운드 재생 실패: \(error.localizedDescription)")
        }
    }

}

extension UIView {
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint

        self.layer.insertSublayer(gradient, at: 0)
    }
}
