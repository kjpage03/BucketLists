//
//  InitialViewController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/11/21.
//

import UIKit

class InitialViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var bucketListLabel: UILabel!
    @IBOutlet weak var newListButton: UIButton!
    //    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var newListButtonWasTapped: Bool = false
    
    var bucketLists: [BucketList] = []
    var indexOfSelectedRow: Int = 0
    
    @IBOutlet weak var stackView: UIStackView!
    var dataSource: UICollectionViewDiffableDataSource<String, BucketList>!
    var viewHasDisappeared: Bool = false
    @IBOutlet weak var collectionView: OrtogonalScrollingCollectionView!
    
    var updatedSnapshot: NSDiffableDataSourceSnapshot<String, BucketList> {
        var snapshot = NSDiffableDataSourceSnapshot<String, BucketList>()
        
        snapshot.appendSections(["Lists"])
        snapshot.appendItems(bucketLists)
        
        return snapshot
    }
    
    var editingSwitchIsOn: Bool = false
    var animatedCell: BucketCollectionViewCell?
    var selectedItem: BucketList?
    
    let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        bucketLists = dataController.retrieveData()
        
        newListButton.layer.cornerRadius = 4
        createDataSource()
        collectionView.collectionViewLayout = generateNewLayout()
        collectionView.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //        scrollLabel.text = "\(1)/\(bucketLists.count)"
        // Do any additional setup after loading the view.
        //        let emitter = CAEmitterLayer()
        //        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        //
        //        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        //        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        //        emitter.emitterCells = generateEmitterCells()
        //        self.view.layer.addSublayer(emitter)
        //    }
    }
    //
    //    private func generateEmitterCells() -> [CAEmitterCell] {
    //        var cells: [CAEmitterCell] = [CAEmitterCell]()
    //        for index in 0..<16 {
    //        let cell = CAEmitterCell()
    //        cell.birthRate = 4.0
    //        cell.lifetime = 14.0
    //        cell.lifetimeRange = 0
    //        cell.velocity = CGFloat.random(in: 0...100)
    //        cell.velocityRange = 0
    //        cell.emissionLongitude = CGFloat(Double.pi)
    //        cell.emissionRange = 0.5
    //        cell.spin = 3.5
    //        cell.spinRange = 0
    //        cell.color = getNextColor(i: index)
    //        cell.contents = UIImage(named: "bucketNoBG")
    //        cell.scaleRange = 0.25
    //        cell.scale = 0.1
    //        cells.append(cell)
    //        }
    //        return cells
    //    }
    //
    //    func getNextColor(i: Any) -> CGColor {
    //        let colors: [CGColor] = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor]
    //
    //        return colors[i as! Int]
    //    }
    
    //    func getNextImage(i: Any) -> UIImage {
    //
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        newListButtonWasTapped = false
        
        bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName) ?? []
        
        dataSource.apply(updatedSnapshot)
        
        //OPTIONAL ZOOM OUT
        
        if viewHasDisappeared {
            UIView.animate(withDuration: 0.5) { [self] in
                collectionView.transform.a /= 50
                collectionView.transform.d /= 50
            } completion: { (_) in
                self.animatedCell!.ownerLabel.isHidden = false
                self.newListButton.isHidden = false
                self.segmentedControl.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.transform = CGAffineTransform.identity
                }
            }
            print(collectionView.transform)
            viewHasDisappeared = false
        }
    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        for cell in self.collectionView.visibleCells {
    //            let indexPath = self.collectionView.indexPath(for: cell)
    //            if let ip = indexPath {
    //                DispatchQueue.main.async {
    //                    self.scrollLabel.text = "\(ip.row+1)/\(self.bucketLists.count)"
    //                }
    //            }
    //        }
    //    }
    
    
    func generateNewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        //        section.visibleItemsInvalidationHandler = { [self] (visibleItems, point, env) -> Void in
        //
        //        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) was selected.")
        let cell = collectionView.cellForItem(at: indexPath) as! BucketCollectionViewCell
        animatedCell = cell
        self.view.sendSubviewToBack(stackView)
        self.view.bringSubviewToFront(collectionView)
        self.newListButton.isHidden = true
        self.segmentedControl.isHidden = true
        cell.ownerLabel.isHidden = true
        self.selectedItem = self.bucketLists[indexPath.row]
        self.indexOfSelectedRow = indexPath.row
        self.viewHasDisappeared = true
        
        UIView.animate(withDuration: 0.5) {
            let rotateTransform = CGAffineTransform(rotationAngle: .pi)
            collectionView.transform = rotateTransform
            //            cell.imageView.transform = rotateTransform
            cell.fill.layer.borderWidth = 0
        }
        completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                //                let scaleTransform = CGAffineTransform(scaleX: 50, y: 50)
                //                collectionView.transform = scaleTransform
                collectionView.transform.a *= 50
                collectionView.transform.d *= 50
            } completion: { (_) in
                if self.editingSwitchIsOn {
                    //segue to edit vc
                    self.performSegue(withIdentifier: "CreateVC", sender: self.bucketLists[indexPath.row])
                    
                } else {
                    //segue to list
                    self.performSegue(withIdentifier: "ListTableView", sender: self.bucketLists[indexPath.row])
                }
            }
        }
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, BucketList>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, bucketList) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bucket", for: indexPath) as! BucketCollectionViewCell
            
            cell.configure(label: bucketList.owner, percentage: bucketList.percentCompleted, color: bucketList.color.uiColor)
            //            cell.layoutIfNeeded()
            return cell
        })
        dataSource.apply(updatedSnapshot)
        
    }
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: editingSwitchIsOn = false
            
        case 1: editingSwitchIsOn = true
            
        default:
            break
        }
    }
    
    @IBAction func unwindToList(unwindSegue: UIStoryboardSegue) {
        
        
    }
    
    @IBAction func unwindFromDelete(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func newListButtonTapped(_ sender: Any) {
        newListButtonWasTapped = true
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let listViewController = segue.destination as? ListTableViewController, let list = selectedItem {
            listViewController.title = list.owner
            listViewController.color = list.color.uiColor
            listViewController.indexOfList = indexOfSelectedRow
            listViewController.bucketLists = bucketLists
            
            for item in list.items {
                if item.isComplete {
                    listViewController.listCompleted.append(item)
                } else {
                    listViewController.list.append(item)
                }
                listViewController.bothList.append(item)
            }
        } else  {
            if let createViewController = segue.destination as? CreateViewController, let list = selectedItem {
                if newListButtonWasTapped {
                    createViewController.title = "New List"
                    createViewController.deleteButtonIsHidden = true
                } else {
                    createViewController.title = "Edit List"
                    createViewController.bucketList = list
                    createViewController.deleteButtonIsHidden = false
                    createViewController.indexInArray = indexOfSelectedRow
                }
            }
        }
    }
}


