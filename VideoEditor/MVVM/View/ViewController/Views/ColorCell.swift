//
//  ColorCell.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

// MARK: - Custom UICollectionViewCell
class ColorCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        contentView.addSubview(numberLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            numberLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.textColor = .darkGray
        numberLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(data: DataModel, index:IndexPath) {
        imageView.image = data.image
        numberLabel.text = "\(index.row + 1)"
    }
}
