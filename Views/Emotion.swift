//
//  Cat.swift
//  CatTranslator
//
//  Created by 김하진 on 6/19/25.
//

import Foundation
import SwiftUI
import CoreLocation

struct Emotion: Hashable, Codable, Identifiable {
    static var imagePool: [String: UIImage] = [:]
    var id: Int
    var name: String
    var description: String
    var imageName: String
    
    init(id: Int, name: String, description: String, imageName: String) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
    }
    
    func uiImage(size: CGSize? = nil, completion: @escaping (UIImage) -> Void) -> Void{

        var image = Emotion.imagePool[imageName]
        if image == nil{
            image = UIImage(named: imageName)!
        }
        if image != nil{
            guard let size = size else{
                completion(image!)
                return
            }
            let resizedImage = image!.resized(to: size)
            Emotion.imagePool[name] = resizedImage
            completion(resizedImage)
            return
        }

    }

    var image: Image {
        Image(imageName)
    }
}


extension Emotion{
    static func toDict(emotion: Emotion) -> [String: Any]{
        var dict = [String: Any]()
        
        dict["id"] = emotion.id
        dict["name"] = emotion.name
        dict["description"] = emotion.description
        dict["imageName"] = emotion.imageName

        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> Emotion{
        
        let id = dict["id"] as! Int
        let name = dict["name"] as! String
        let description = dict["description"] as! String
        let imageName = dict["imageName"] as! String

        return Emotion(id: id, name: name, description: description, imageName: imageName)
    }
}



