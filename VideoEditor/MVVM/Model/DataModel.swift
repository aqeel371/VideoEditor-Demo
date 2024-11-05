//
//  DataModel.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

struct DataModel {
    var value: Int
    var image: UIImage?

    static func setupDataModels() -> [DataModel] {
        return Array(1...5).map { DataModel(value: $0 * 5, image: UIImage(named: "ic_demo")) }
    }

    static func setupDataModels1() -> [DataModel] {
        return Array(1...5).map { DataModel(value: $0 * 10, image: UIImage(named: "ic_demo1")) }
    }

    static func setupDataModels2() -> [DataModel] {
        return Array(1...5).map { DataModel(value: $0 * 15, image: UIImage(named: "ic_demo2")) }
    }
}
