
//
//  ZoomableCollectionViewController.swift
//  VideoEditor
//
//  Created by Devsonics Mac Mini on 05/11/2024.
//

import UIKit

class ZoomableCollectionViewController: UIViewController {
    
    // MARK: - Variables
    private var collectionView: UICollectionView!
    private var collectionView1: UICollectionView!
    private var collectionView2: UICollectionView!
    private let cellReuseIdentifier = "ColorCell"
    private var zoomScale: CGFloat = 1.0
    
    // ViewModels for each collection view
    private var viewModel: ZoomableCollectionViewModel!
    private var viewModel1: ZoomableCollectionViewModel!
    private var viewModel2: ZoomableCollectionViewModel!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ZoomableCollectionViewModel(dataModels: DataModel.setupDataModels())
        viewModel1 = ZoomableCollectionViewModel(dataModels: DataModel.setupDataModels1())
        viewModel2 = ZoomableCollectionViewModel(dataModels: DataModel.setupDataModels2())
        
        setupCollectionViews()
        setupPinchGestures()
        setupVerticalLine()
    }
    
    private func setupCollectionViews() {
        let collectionViewHeight: CGFloat = 80
        let collectionViewY: CGFloat = 100
        
        collectionView = createCollectionView()
        collectionView1 = createCollectionView()
        collectionView2 = createCollectionView()
        
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: view.bounds.width, height: collectionViewHeight)
        collectionView1.frame = CGRect(x: 0, y: collectionViewY + collectionViewHeight + 30, width: view.bounds.width, height: collectionViewHeight)
        collectionView2.frame = CGRect(x: 0, y: collectionViewY + (collectionViewHeight + 30) * 2, width: view.bounds.width, height: collectionViewHeight)
        
        self.view.addSubview(collectionView)
        self.view.addSubview(collectionView1)
        self.view.addSubview(collectionView2)
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 80)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dragInteractionEnabled = true
        return collectionView
    }

    private func setupPinchGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let pinchGesture1 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture1(_:)))
        let pinchGesture2 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture2(_:)))
        
        collectionView.addGestureRecognizer(pinchGesture)
        collectionView1.addGestureRecognizer(pinchGesture1)
        collectionView2.addGestureRecognizer(pinchGesture2)
    }

    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        handlePinchGesture(for: collectionView, gesture: gesture, viewModel: viewModel)
    }
    
    @objc private func handlePinchGesture1(_ gesture: UIPinchGestureRecognizer) {
        handlePinchGesture(for: collectionView1, gesture: gesture, viewModel: viewModel1)
    }
    
    @objc private func handlePinchGesture2(_ gesture: UIPinchGestureRecognizer) {
        handlePinchGesture(for: collectionView2, gesture: gesture, viewModel: viewModel2)
    }

    private func handlePinchGesture(for collectionView: UICollectionView, gesture: UIPinchGestureRecognizer, viewModel: ZoomableCollectionViewModel) {
        let pinchLocation = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pinchLocation) else { return }

        let zoomIn = gesture.scale > 1.0
        if gesture.state == .began || gesture.state == .changed, viewModel.handlePinchGesture(at: indexPath, zoomIn: zoomIn) {
            collectionView.performBatchUpdates {
                if zoomIn {
                    collectionView.insertItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                } else {
                    collectionView.deleteItems(at: [IndexPath(item: indexPath.item + 1, section: 0)])
                }
            } completion: { _ in
                collectionView.reloadData()
            }
        }
        gesture.scale = 1.0
    }
    
    private func setupVerticalLine() {
        let verticalLine = UIView()
        verticalLine.backgroundColor = .red
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(verticalLine)
        
        NSLayoutConstraint.activate([
            verticalLine.widthAnchor.constraint(equalToConstant: 2),
            verticalLine.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.topAnchor, multiplier: -5),
            verticalLine.bottomAnchor.constraint(equalToSystemSpacingBelow: collectionView2.bottomAnchor, multiplier: 5),
            verticalLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ZoomableCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.totalItems
        } else if collectionView == self.collectionView1 {
            return viewModel1.totalItems
        } else {
            return viewModel2.totalItems
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ColorCell
        let model = collectionView == self.collectionView ? viewModel.dataModels[indexPath.item] : collectionView == self.collectionView1 ? viewModel1.dataModels[indexPath.item] : viewModel2.dataModels[indexPath.item]
        cell.populate(data: model, index: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension ZoomableCollectionViewController: UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    // Enabling drag for items in the collection view.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let model = collectionView == self.collectionView ? viewModel.dataModels[indexPath.item] : collectionView == self.collectionView1 ? viewModel1.dataModels[indexPath.item] : viewModel2.dataModels[indexPath.item]
        let itemProvider = NSItemProvider(object: "\(model.value)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = model
        return [dragItem]
    }

    // Handling the drop of an item.
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        let destinationViewModel = collectionView == self.collectionView ? viewModel : collectionView == self.collectionView1 ? viewModel1 : viewModel2

        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath, let model = dropItem.dragItem.localObject as? DataModel {
                collectionView.performBatchUpdates({
                    destinationViewModel?.dataModels.remove(at: sourceIndexPath.item)
                    destinationViewModel?.dataModels.insert(model, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: {
                    _ in
                    collectionView.reloadData()
                })
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }

    // Supporting drop proposal.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
