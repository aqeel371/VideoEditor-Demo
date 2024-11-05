
//
//  ZoomableCollectionViewController.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

class ZoomableCollectionViewController: UIViewController {
    
    //MARK: - Variables
    private var collectionView: UICollectionView!
    private var collectionView1: UICollectionView!
    private var collectionView2: UICollectionView!
    private var zoomScale: CGFloat = 1.0
    private let cellReuseIdentifier = "ColorCell"
    private var totalItems: Int = 5
    private var totalItems1: Int = 5
    private var totalItems2: Int = 5
    private let minimumItems: Int = 5
    private let maximumItems: Int = 25
    private var dataModels: [DataModel] = DataModel.setupDataModels()
    private var dataModels1: [DataModel] = DataModel.setupDataModels1()
    private var dataModels2: [DataModel] = DataModel.setupDataModels2()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPinchGesture()
        setupCollectionView1()
        setupPinchGesture1()
        setupCollectionView2()
        setupPinchGesture2()
        
        // Set frames for each collection view
        let collectionViewHeight: CGFloat = 80
        let collectionViewY: CGFloat = 100 // Adjust as needed for spacing
        
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: view.bounds.width, height: collectionViewHeight)
        collectionView1.frame = CGRect(x: 0, y: collectionViewY + collectionViewHeight + 30, width: view.bounds.width, height: collectionViewHeight)
        collectionView2.frame = CGRect(x: 0, y: collectionViewY + (collectionViewHeight + 30) * 2, width: view.bounds.width, height: collectionViewHeight)
        
        self.view.addSubview(collectionView)
        self.view.addSubview(collectionView1)
        self.view.addSubview(collectionView2)
        
        setupVerticalLine()
    }
    
    //MARK: - Setup
    private func setupVerticalLine() {
        let verticalLine = UIView()
        verticalLine.backgroundColor = .red // Set the color of the line
        verticalLine.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        
        // Add the vertical line to the main view
        self.view.addSubview(verticalLine)
        
        // Set the constraints for the vertical line
        NSLayoutConstraint.activate([
            verticalLine.widthAnchor.constraint(equalToConstant: 2), // Width of the line
            verticalLine.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.topAnchor, multiplier: -5),
            verticalLine.bottomAnchor.constraint(equalToSystemSpacingBelow: collectionView2.bottomAnchor, multiplier: 5),
            verticalLine.heightAnchor.constraint(equalToConstant: 300),
            verticalLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor) // Center horizontally
        ])
    }
    
}

// MARK: - UICollectionViewDataSource
extension ZoomableCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return totalItems
        }else if collectionView == collectionView1{
            return totalItems1
        }else{
            return totalItems2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ColorCell
        if collectionView == self.collectionView {
            let dataModel = dataModels[indexPath.item]
            cell.populate(data: dataModel, index: indexPath)
        } else if collectionView == self.collectionView1 {
            let dataModel = dataModels1[indexPath.item]
            cell.populate(data: dataModel, index: indexPath)
        } else {
            let dataModel = dataModels2[indexPath.item]
            cell.populate(data: dataModel, index: indexPath)
        }
        
        return cell
        
    }
}

// MARK: - UICollectionViewDelegates Drag and Drop
extension ZoomableCollectionViewController: UICollectionViewDelegate ,UICollectionViewDragDelegate,UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = "\(indexPath.item)"
        let itemProvider = NSItemProvider(object: NSString(string: "\(indexPath.item)"))
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        print("DRAG ITEM IN BEGIN: \(item)")
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        if collectionView == self.collectionView{
            if let item = coordinator.items.first,
               let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates {
                    let objNeedToInsert = dataModels[Int(item.dragItem.localObject as! String)!]
                    self.dataModels.remove(at: sourceIndexPath.item)
                    self.dataModels.insert(objNeedToInsert, at: destinationIndexPath.item)
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.collectionView.reloadData()
                })
                
            }
        }else if collectionView == collectionView1{
            if let item = coordinator.items.first,
               let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates {
                    let objNeedToInsert = dataModels1[Int(item.dragItem.localObject as! String)!]
                    self.dataModels1.remove(at: sourceIndexPath.item)
                    self.dataModels1.insert(objNeedToInsert, at: destinationIndexPath.item)
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.collectionView1.reloadData()
                })
            }
        }else{
            if let item = coordinator.items.first,
               let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates {
                    let objNeedToInsert = dataModels2[Int(item.dragItem.localObject as! String)!]
                    self.dataModels2.remove(at: sourceIndexPath.item)
                    self.dataModels2.insert(objNeedToInsert, at: destinationIndexPath.item)
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.collectionView2.reloadData()
                })
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
}


//MARK: - CollectionView 1

extension ZoomableCollectionViewController{
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 80)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.bounds.size.height = 80
    }
    
    private func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        
        let pinchLocation = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pinchLocation) else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            // Check if we are zooming in or out
            let zoomIn = gesture.scale > 1.0
            
            // Ensure indexPath is within bounds
            if indexPath.item < dataModels.count {
                if zoomIn {
                    // Zooming in: Add a cell at the indexPath
                    let newValue = dataModels[indexPath.item].value + 1 // For example, increment the value
                    let newImage = UIImage(named: "ic_demo") // Replace with your image
                    let newModel = DataModel(value: newValue, image: newImage)
                    
                    dataModels.insert(newModel, at: indexPath.item + 1) // Insert right after the current item
                    totalItems += 1
                    
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                    }, completion: {_ in
                        collectionView.reloadData()
                    })
                    
                } else {
                    // Zooming out: Remove the cell at the indexPath + 1 if it exists
                    if indexPath.item + 1 < totalItems {
                        dataModels.remove(at: indexPath.item + 1)
                        totalItems -= 1
                        
                        collectionView.performBatchUpdates({
                            collectionView.deleteItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                        }, completion: {
                            _ in
                            collectionView.reloadData()
                        })
                    }
                }
            }
            gesture.scale = 1.0 // Reset scale to avoid compounding zoom
        }
        collectionView.reloadData()
    }
}

//MARK: - CollectionVIew 2
extension ZoomableCollectionViewController{
    
    private func setupCollectionView1() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 80)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView1 = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView1.backgroundColor = .white
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        collectionView1.register(ColorCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView1.bounds.size.height = 80
    }
    
    private func setupPinchGesture1() {
        let pinchGesture1 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture1(_:)))
        collectionView1.addGestureRecognizer(pinchGesture1)
    }
    
    @objc private func handlePinchGesture1(_ gesture: UIPinchGestureRecognizer) {
        guard let collectionView = collectionView1 else { return }
        
        let pinchLocation = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pinchLocation) else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            // Check if we are zooming in or out
            let zoomIn = gesture.scale > 1.0
            
            // Ensure indexPath is within bounds
            if indexPath.item < dataModels1.count {
                if zoomIn {
                    // Zooming in: Add a cell at the indexPath
                    let newValue = dataModels1[indexPath.item].value + 1 // For example, increment the value
                    let newImage = UIImage(named: "ic_demo1") // Replace with your image
                    let newModel = DataModel(value: newValue, image: newImage)
                    
                    dataModels1.insert(newModel, at: indexPath.item + 1) // Insert right after the current item
                    totalItems1 += 1
                    
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                    }, completion: {_ in
                        collectionView.reloadData()
                    })
                    
                } else {
                    // Zooming out: Remove the cell at the indexPath + 1 if it exists
                    if indexPath.item + 1 < totalItems1{
                        dataModels1.remove(at: indexPath.item + 1)
                        totalItems1 -= 1
                        
                        collectionView.performBatchUpdates({
                            collectionView.deleteItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                        }, completion: {
                            _ in
                            collectionView.reloadData()
                        })
                    }
                }
            }
            gesture.scale = 1.0 // Reset scale to avoid compounding zoom
        }
        collectionView.reloadData()
    }
    
    
}


//MARK: - CollectionVIew 3
extension ZoomableCollectionViewController{
    
    private func setupCollectionView2() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 80)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView2 = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView2.backgroundColor = .white
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.dragDelegate = self
        collectionView2.dropDelegate = self
        collectionView2.register(ColorCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView2.bounds.size.height = 80
    }
    
    private func setupPinchGesture2() {
        let pinchGesture2 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture2(_:)))
        collectionView2.addGestureRecognizer(pinchGesture2)
    }
    
    @objc private func handlePinchGesture2(_ gesture: UIPinchGestureRecognizer) {
        guard let collectionView = collectionView2 else { return }
        
        let pinchLocation = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pinchLocation) else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            // Check if we are zooming in or out
            let zoomIn = gesture.scale > 1.0
            
            // Ensure indexPath is within bounds
            if indexPath.item < dataModels2.count {
                if zoomIn {
                    // Zooming in: Add a cell at the indexPath
                    let newValue = dataModels2[indexPath.item].value + 1 // For example, increment the value
                    let newImage = UIImage(named: "ic_demo2") // Replace with your image
                    let newModel = DataModel(value: newValue, image: newImage)
                    
                    dataModels2.insert(newModel, at: indexPath.item + 1) // Insert right after the current item
                    totalItems2 += 1
                    
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                    }, completion: {_ in
                        collectionView.reloadData()
                    })
                    
                } else {
                    // Zooming out: Remove the cell at the indexPath + 1 if it exists
                    if indexPath.item + 1 < totalItems2 {
                        dataModels2.remove(at: indexPath.item + 1)
                        totalItems2 -= 1
                        
                        collectionView.performBatchUpdates({
                            collectionView.deleteItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                        }, completion: {
                            _ in
                            collectionView.reloadData()
                        })
                    }
                }
            }
            gesture.scale = 1.0 // Reset scale to avoid compounding zoom
        }
        collectionView.reloadData()
    }
    
    
}

