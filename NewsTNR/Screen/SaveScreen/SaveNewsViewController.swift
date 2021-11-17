//
//  ProfileViewController.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit
import CoreData

// MARK: - SaveNewsViewControllerProtocol
protocol SaveNewsViewControllerProtocol {
    func update(with models: [NSManagedObject], animated: Bool)
}

// MARK: - SaveNewsViewController
class SaveNewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var presenter: SaveNewsPresenterProtocol
    private lazy var dataSource = configureDataSource()
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "NewsTNR")
    }()
    
    
    // MARK: - Init
    init(presenter: SaveNewsPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        setupUI()
        view.showActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNews()
    }
}

// MARK: - Private Extension
private extension SaveNewsViewController {
    func setupUI() {
        setupCollectionView()
        setupNavigationController()
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
        newsCollectionView.register(SaveNewsCell.nib, forCellWithReuseIdentifier: SaveNewsCell.identifier)
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = "Favourite"
    }
    
    func animateOpacity() {
        newsCollectionView.layer.opacity = 0
        UIView.animate(withDuration: 0.5) {
            self.newsCollectionView.layer.opacity = 1
        }
    }
}

// MARK: - SaveNewsViewController
extension SaveNewsViewController: SaveNewsViewControllerProtocol, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let object = dataSource.itemIdentifier(for: indexPath) else { return }
        let saveNews = createNews(model: object)
        guard let image = saveNews.image, let data = image.pngData() else { return }
        let news = Result(title: saveNews.title, image: data, isSaveNews: true)
        presenter.showDetailNewsVC(view: self, news: news)
    }
    
    func update(with models: [NSManagedObject], animated: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObject>()
            
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
    
    private func alreadyGetNews() {
        newsCollectionView.isHidden = false
        view.hideActivityIndicatorView()
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Int, NSManagedObject> {
        let dataSource = UICollectionViewDiffableDataSource<Int, NSManagedObject>(
            collectionView: newsCollectionView) { [weak self] collectionView, indexPath, model in
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: SaveNewsCell.identifier, for: indexPath) as? SaveNewsCell)?.config(with: self?.createNews(model: model))
                cell?.completion = { [weak self] in
                    self?.deleteNews(object: model, index: indexPath.row)
                }
                return cell
            }
        
        return dataSource
    }
    
    private func createNews(model: NSManagedObject) -> SaveNews {
        let title = model.value(forKey: "name") as! String
        let data = model.value(forKey: "image") as! Data
        let image = UIImage(data: data)
        let news = SaveNews(title: title, image: image)
        
        return news
    }
}

// MARK: - Composit layout
extension SaveNewsViewController {
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: presenter.news.count == 1 ? .fractionalWidth(1.0) : .absolute(UIScreen.main.bounds.width - 28),
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

// MARK: - CoreData
extension SaveNewsViewController {
    private func getNews() {
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self?.fetchNews()
            }
        }
    }
    
    private func fetchNews() {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "NewsEntity")
        let managedContext = persistentContainer.viewContext
        
        do {
            let news = try managedContext.fetch(fetchRequest)
            presenter.news = news
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print()
    }
    
    private func deleteNews(object: NSManagedObject, index: Int) {
        let managedContext = persistentContainer.viewContext
        managedContext.delete(object)
        presenter.news.remove(at: index)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
