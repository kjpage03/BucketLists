//
//  InitialViewController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/11/21.
//

import UIKit
import AVFoundation

class InitialViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var bucketListLabel: UILabel!
    @IBOutlet weak var newListButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: OrtogonalScrollingCollectionView!
    
    var newListButtonWasTapped: Bool = false
    var bucketLists: [BucketList] = []
    var indexOfSelectedRow: Int = 0
    var originalLayerCount: Int = Int()
    var dataSource: UICollectionViewDiffableDataSource<String, BucketList>!
    var viewHasDisappeared: Bool = false
    var editingSwitchIsOn: Bool = false
    var animatedCell: BucketCollectionViewCell?
    var selectedItem: BucketList?
    let dataController = DataController()
    var particleController: ParticleController!
    var img: UIImage?
    var bucketSplashSoundEffect: AVAudioPlayer?
    
    var updatedSnapshot: NSDiffableDataSourceSnapshot<String, BucketList> {
        var snapshot = NSDiffableDataSourceSnapshot<String, BucketList>()
        
        snapshot.appendSections(["Lists"])
        snapshot.appendItems(bucketLists)
        
        return snapshot
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        requestAuthorization()
        
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
        particleController = ParticleController(view: self.view)
        
        if UIDevice.modelName == "Simulator iPhone 12"{
        particleController.createBackgroundParticles()
        }
//        particleController = ParticleController(view: self.collectionView.visibleCells.first!.contentView)
//        particleController = ParticleController(view: self.view)
        originalLayerCount = self.view.layer.sublayers!.count
        
    }
    
    fileprivate func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success")
            }
        }
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "waterSplash.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            bucketSplashSoundEffect = try AVAudioPlayer(contentsOf: url)
            bucketSplashSoundEffect?.play()
        } catch {
            print("File not found")
            // couldn't load file :(
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
    
        self.dataSource.apply(self.updatedSnapshot)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        newListButtonWasTapped = false
        
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
                particleController.createParticles()
                Timer.scheduledTimer(withTimeInterval: 5,
                                     repeats: false) { _ in
                    
                    self.removeParticles()
                }
                
                Timer.scheduledTimer(withTimeInterval: 3,
                                     repeats: false) { _ in
                    let bounds = self.view.bounds
                    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
                    self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
                    self.img = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
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
            ac.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: nil))
            ac.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
                let activityViewController = UIActivityViewController(activityItems: [self.img!], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }))
            
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func generateNewLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
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
        
        
        
        Timer.scheduledTimer(withTimeInterval: 0.25,
                             repeats: false) { _ in
            self.playSound()
        }

        
        UIView.animate(withDuration: 0.5) {
            let rotateTransform = CGAffineTransform(rotationAngle: .pi)
            collectionView.transform = rotateTransform
            cell.fill.layer.borderWidth = 0
        }
        completion: { (_) in
            UIView.animate(withDuration: 0.5) {
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
    
    @IBAction func unwindToList(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindFromDelete(unwindSegue: UIStoryboardSegue) {}
    
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


