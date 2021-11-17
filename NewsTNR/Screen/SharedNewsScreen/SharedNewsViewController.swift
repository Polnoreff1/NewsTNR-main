//
//  SharedNewsViewController.swift
//  NewsTNR
//
//  Created by Andrey Versta on 17.11.2021.
//

import UIKit
import CoreData

protocol SharedNewsViewControllerProtocol {
    func update(with models: [Result], animated: Bool)
}

class SharedNewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var newsSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var newsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    
    private let presenter: SharedNewsPresenterProtocol
    private lazy var dataSource = configureDataSource()
    
    // MARK: - Init
    init(presenter: SharedNewsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.showActivityIndicator()
        presenter.getNews(period: 1)
    }
}

// MARK: - Private Extension
private extension SharedNewsViewController {
    func setupUI() {
        newsSegmentedControl.dropShadow(radius: 3, xOffset: 0, yOffset: 1, shadowOpacity: 0.3, shadowColor: .black)
        setupCollectionView()
        setupNavigationController()
        setupSegmentView()
    }
    
    func setupSegmentView() {
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        newsSegmentedControl.layer.borderWidth = 1
        newsSegmentedControl.layer.borderColor = UIColor.black.cgColor
        newsSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        newsSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
    }
    
    func setupCollectionView() {
        newsCollectionView.isHidden = true
        newsCollectionView.backgroundColor = .clear
        newsCollectionView.showsHorizontalScrollIndicator = false
        newsCollectionView.bounces = false
        newsCollectionView.isPagingEnabled = true
        newsCollectionView.collectionViewLayout = createLayout()
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = dataSource
        newsCollectionView.register(NewsCell.nib, forCellWithReuseIdentifier: NewsCell.identifier)
    }
    
    func setupNavigationController() {
        let logo = UIImage(systemName: "newspaper")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    func animateOpacity() {
        newsCollectionView.layer.opacity = 0
        UIView.animate(withDuration: 0.5) {
            self.newsCollectionView.layer.opacity = 1
        }
    }
}

// MARK: - Action
extension SharedNewsViewController {
    @IBAction func choisePeriod(_ sender: UISegmentedControl) {
        var period: Int = 1
        switch newsSegmentedControl.selectedSegmentIndex {
        case 0: period = 1
        case 1: period = 7
        case 2: period = 30
        default: break
        }
        
        presenter.getNews(period: period)
        view.showActivityIndicator()
        newsCollectionView.isHidden = true
    }
}

extension SharedNewsViewController: SharedNewsViewControllerProtocol, UICollectionViewDelegate {
    
    func update(with models: [Result], animated: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Result>()
            
            snapshot.appendSections([0])
            snapshot.appendItems(models)
            
            if #available(iOS 15.0, *) {
                self?.dataSource.applySnapshotUsingReloadData(snapshot, completion: { [weak self] in
                    self?.alreadyGetNews()
                })
            } else {
                self?.dataSource.apply(snapshot, animatingDifferences: animated, completion: { [weak self] in
                    self?.alreadyGetNews()
                })
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter.showDetailNewsVC(view: self, news: news)
    }
    
    private func alreadyGetNews() {
        newsCollectionView.isHidden = false
        animateOpacity()
        view.hideActivityIndicatorView()
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Result> {
        let dataSource = UICollectionViewDiffableDataSource<Int, Result>(
            collectionView: newsCollectionView) { collectionView, indexPath, model in
                (collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell)?.config(with: model)
            }
        
        return dataSource
    }
}

// MARK: - Composit layout
extension SharedNewsViewController {
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 28),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        
        return layout
    }
}


