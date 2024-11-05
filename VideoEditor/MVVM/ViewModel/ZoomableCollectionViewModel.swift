//
//  ZoomableCollectionViewModel.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

class ZoomableCollectionViewModel {
    var dataModels: [DataModel]
    var totalItems: Int
    private let minimumItems = 5
    private let maximumItems = 25

    init(dataModels: [DataModel]) {
        self.dataModels = dataModels
        self.totalItems = dataModels.count
    }

    func handlePinchGesture(at indexPath: IndexPath, zoomIn: Bool) -> Bool {
        guard indexPath.item < dataModels.count else { return false }

        if zoomIn, totalItems < maximumItems {
            let newValue = dataModels[indexPath.item].value + 1
            let newImage = dataModels[indexPath.item].image
            let newModel = DataModel(value: newValue, image: newImage)
            dataModels.insert(newModel, at: indexPath.item + 1)
            totalItems += 1
            return true
        } else if !zoomIn, totalItems > minimumItems {
            dataModels.remove(at: indexPath.item + 1)
            totalItems -= 1
            return true
        }
        return false
    }
}
