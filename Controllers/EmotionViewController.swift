//
//  EmotionViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/19/25.
//

import UIKit

class EmotionViewController: UIViewController {

    @IBOutlet weak var emotionPickerView: UIPickerView!
    @IBOutlet weak var tmiLabel: UILabel!
    
    var emotions: [Emotion] = CatTranslator.load("catData.json")
    
    override func loadView(){
        super.loadView()
        print("EmotionViewController.loadView")
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tmiLabel.layer.cornerRadius = 10
        tmiLabel.clipsToBounds = true
        
        // 배경 뷰에 그라데이션 적용
        view.applyGradient(colors: [
            UIColor(red: 210/255, green: 245/255, blue: 235/255, alpha: 1),  // 연한 민트 (Mint Cream 느낌)
            UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1)   // 연하늘 + 연보라 느낌
        ])
        
        print("EmotionViewController.viewDidLoad")
        
        emotionPickerView.dataSource = self // 데이터 공급자로 등록
        emotionPickerView.delegate = self // 대리자로 등록
        
        emotionPickerView.selectRow(0, inComponent: 0, animated: true)
        tmiLabel.text = emotions[0].description
        
        for emotion in emotions{
            print(emotion)
        }
    }
}

extension EmotionViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emotions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let nameLabel = UILabel()
        nameLabel.text = emotions[row].name
        nameLabel.textAlignment = .center
        let imageView = UIImageView(image: UIImage(named: emotions[row].name))
        let outer = UIStackView(arrangedSubviews: [imageView, nameLabel])
        outer.axis = .vertical
        return outer
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return emotionPickerView.frame.size.height / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tmiLabel.text = emotions[row].description
    }
}

extension EmotionViewController{
    func getSelectedCity() -> String{
        return emotions[emotionPickerView.selectedRow(inComponent: 0)].name
    }
}
