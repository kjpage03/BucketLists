//
//  InitialViewController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/11/21.
//

import UIKit

class InitialViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    enum scrollDirection {
        case upndown
        case leftnright
    }
    
    @IBOutlet weak var bucketListLabel: UILabel!
    @IBOutlet weak var newListButton: UIButton!
    //    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var scrollingBehavior = scrollDirection.leftnright {
        didSet {
            if scrollingBehavior == .leftnright {
                //scrolls left and right
            } else {
                //scrolls up and down
            }
        }
    }
    

    var bucketLists: [BucketList] = BucketList.testBucketLists

    
    var dataSource: UICollectionViewDiffableDataSource<String, BucketList>!
    
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let cell = animatedCell else { return }
        //fix all animations
        collectionView.transform = CGAffineTransform.identity
        cell.imageView.transform = CGAffineTransform.identity
        cell.ownerLabel.isHidden = false
        self.newListButton.isHidden = false
        self.segmentedControl.isHidden = false
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
        self.view.bringSubviewToFront(collectionView)
        self.newListButton.isHidden = true
        self.segmentedControl.isHidden = true
        cell.ownerLabel.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            let rotateTransform = CGAffineTransform(rotationAngle: .pi)
            cell.imageView.transform = rotateTransform
        }
        completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                let scaleTransform = CGAffineTransform(scaleX: 50, y: 50)
                collectionView.transform = scaleTransform
            } completion: { (_) in
                if self.editingSwitchIsOn {
                    //segue to edit vc
                } else {
                    //segue to list
                    self.selectedItem = self.bucketLists[indexPath.row]
                    self.performSegue(withIdentifier: "ListTableView", sender: self.bucketLists[indexPath.row])
                }
            }
        }
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, BucketList>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, bucketList) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bucket", for: indexPath) as! BucketCollectionViewCell
            cell.configure(label: bucketList.owner)
            cell.layoutIfNeeded()
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

    
//      MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listViewController = segue.destination as? ListTableViewController, let list = selectedItem {
            listViewController.title = list.owner
            for item in list.items {
                if item.isComplete {
                    listViewController.listCompleted.append(item)
                } else {
                    listViewController.list.append(item)
                }
                listViewController.bothList.append(item)
            }
        }
     }
    
}
