//
//  DataModel.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

struct DataModel:Equatable{
        let value: Int
        let image: UIImage?
    
    
    // Data 1
    static func setupDataModels() -> [DataModel]{
        var data:[DataModel] = []
        // Create DataModel instances for initial items (1 to 5)
        for i in 1...25 {
            let image = UIImage(named: "ic_demo") // Replace with your image
            data.append(DataModel(value: i, image: image))
        }
        
        return data
    }
    
    // Data 2
    static func setupDataModels1() -> [DataModel]{
        var data:[DataModel] = []
        // Create DataModel instances for initial items (1 to 5)
        for i in 1...25 {
            let image = UIImage(named: "ic_demo1") // Replace with your image
            data.append(DataModel(value: i, image: image))
        }
        
        return data
    }
    
    // Data 3
    static func setupDataModels2() -> [DataModel]{
        var data:[DataModel] = []
        // Create DataModel instances for initial items (1 to 5)
        for i in 1...25 {
            let image = UIImage(named: "ic_demo2") // Replace with your image
            data.append(DataModel(value: i, image: image))
        }
        
        return data
    }
}
