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
    var originalLayerCount: Int = Int()
    
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
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted: Bool, error: Error?) in
            if let error = error {
               print(error.localizedDescription)
            } else {
               print("Success")
            }
        }

        //        bucketLists = dataController.retrieveData()
        
        newListButton.layer.cornerRadius = 4
        createDataSource()
        collectionView.collectionViewLayout = generateNewLayout()
        collectionView.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        


        bucketListLabel.layer.shadowColor = UIColor.black.cgColor
        bucketListLabel.layer.shadowOpacity = 0.3
        bucketListLabel.layer.shadowOffset = .zero
        bucketListLabel.layer.shadowRadius = 10
        
        view.bringSubviewToFront(stackView)

        createBackgroundParticles()
        originalLayerCount = self.view.layer.sublayers!.count
        
    }
    
    func createBackgroundParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.frame.height + 50)
        //        -96
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let cell = makeEmitterCell(color: UIColor.black, type: .background)
        
        particleEmitter.emitterCells = [cell]
                
        view.layer.addSublayer(particleEmitter)
//        view.layer.sublayers?.insert(particleEmitter, at: 0)
        
        let topEmitter = CAEmitterLayer()
        topEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        
        topEmitter.emitterShape = .line
        topEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        topEmitter.emitterCells = [cell]
        view.layer.addSublayer(topEmitter)
//        view.layer.sublayers?.insert(topEmitter, at: 0)
        
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        //        -96
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let red = makeEmitterCell(color: .red, type: .exploding)
        let green = makeEmitterCell(color: .green, type: .exploding)
        let blue = makeEmitterCell(color: .blue, type: .exploding)
        let yellow = makeEmitterCell(color: .yellow, type: .exploding)
        
        particleEmitter.emitterCells = [red, green, blue, yellow]
        
        view.layer.addSublayer(particleEmitter)
    }
    
    enum CellEmitterType {
        case exploding
        case background
    }
    
    func makeEmitterCell(color: UIColor, type: CellEmitterType) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        //original
        
        //        cell.scale = 0.2
        //        cell.birthRate = 3
        //        cell.lifetime = 7.0
        //        cell.lifetimeRange = 0
        //        cell.color = color.cgColor
        //        cell.velocity = 200
        //        cell.velocityRange = 50
        //        cell.emissionLongitude = CGFloat.pi
        //        cell.emissionRange = CGFloat.pi / 4
        //        cell.spin = 2
        //        cell.spinRange = 3
        //        cell.scaleRange = 0.5
        //        cell.scaleSpeed = -0.05
        
        //modified
        
        //        cell.scale = 0.2
        //        cell.birthRate = 5
        //        cell.lifetime = 7.0
        //        cell.lifetimeRange = 0
        //        cell.color = color.cgColor
        //        cell.velocity = 300
        //        cell.velocityRange = 50
        //        cell.emissionLongitude = CGFloat.pi
        //        cell.emissionRange = CGFloat.pi / 4
        //        cell.spin = 3
        //        cell.spinRange = 3
        //        cell.scaleRange = 0.5
        //        cell.scaleSpeed = -0.05
        
        switch type {
        
        case .exploding :
            
            cell.scale = 0.2
            cell.birthRate = 5
            cell.lifetime = 7.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 300
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scaleRange = 0
            cell.scaleSpeed = -0.05
            
            cell.contents = UIImage(named: "bucket5")?.cgImage

        //        cell.scale = 0.2
        //        cell.birthRate = 5
        //        cell.lifetime = 7.0
        //        cell.lifetimeRange = 0
        //        cell.color = color.cgColor
        //        cell.velocity = 300
        //        cell.velocityRange = 50
        //        cell.emissionLongitude = 0
        //        cell.emissionRange = CGFloat.pi
        //        cell.spin = 3
        //        cell.spinRange = 3
        //        cell.scaleRange = 0.5
        //        cell.scaleSpeed = -0.05
        
        case .background:
            
            cell.scale = 0.5
            cell.birthRate = 0.2
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 50
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi / 2
            cell.emissionRange = CGFloat.pi
            cell.spin = 1
            cell.spinRange = 3
            cell.scaleRange = 0
            cell.scaleSpeed = -0.05
            cell.contents = UIImage(named: "bucketNoBG")?.cgImage

        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        newListButtonWasTapped = false
        
        bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
        
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
        
        if bucketLists.count > 0 {
            let pathName = bucketLists[indexOfSelectedRow].id.uuidString
            if dataController.retrieveValue(pathName: pathName)?.first == false {
                createParticles()
                Timer.scheduledTimer(withTimeInterval: 5,
                                     repeats: false) { _ in
                    self.removeParticles()
                }
                dataController.saveData(data: [true], pathName: pathName)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if view.layer.sublayers!.count > originalLayerCount {
            view.layer.sublayers?.removeLast()
        }
    }
    
    func removeParticles() {
        UIView.animate(withDuration: 3) {
            self.view.layer.sublayers?.last?.opacity = 0
        } completion: { (_) in
            let ac = UIAlertController(title: "Nice Job!", message: "You completed a list!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Thanks", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
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


