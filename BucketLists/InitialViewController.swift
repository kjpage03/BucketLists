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
    
    var bucketLists: [BucketList] = [BucketList(owner: "Kaleb's List", items: [], color: "Red"), BucketList(owner: "Chris's List", items: [], color: "Blue"), BucketList(owner: "Jake's List", items: [], color: "Green")]
    
    var dataSource: UICollectionViewDiffableDataSource<String, BucketList>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var updatedSnapshot: NSDiffableDataSourceSnapshot<String, BucketList> {
        var snapshot = NSDiffableDataSourceSnapshot<String, BucketList>()
        
        snapshot.appendSections(["Lists"])
        snapshot.appendItems(bucketLists)
        
        return snapshot
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newListButton.layer.cornerRadius = 4
        createDataSource()
        collectionView.collectionViewLayout = generateNewLayout()
        collectionView.delegate = self
//        scrollLabel.text = "\(1)/\(bucketLists.count)"
        // Do any additional setup after loading the view.
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
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(308)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(308)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
//        section.visibleItemsInvalidationHandler = { [self] (visibleItems, point, env) -> Void in
//
//        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
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
    
    
    @IBAction func newListTapped(_ sender: Any) {
        
        //segue to new view controller
        
    }
    
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: scrollingBehavior = .upndown
            
        case 1: scrollingBehavior = .leftnright
            
        default:
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
