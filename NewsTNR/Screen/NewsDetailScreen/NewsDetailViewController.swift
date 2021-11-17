//
//  NewsDetailViewController.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit
import CoreData

// MARK: - NewsDetailViewController
class NewsDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - Properties
    private let presenter: NewsDetailPresenterProtocol
    private var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - Init
    init(presenter: NewsDetailPresenterProtocol) {
        self.presenter = presenter
        self.managedObjectContext = AppDelegate.shared.persistentContainer.viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Extension
private extension NewsDetailViewController {
    func setupUI() {
        addCustomizeNavigationBackButton(type: .back, completion: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        setupNavigationController()
        setupNewsImageView()
    }
    
    func setupNavigationController() {
        if presenter.news.isSaveNews != true {
            let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewsInBase))
            button.tintColor = .black
            navigationItem.rightBarButtonItem = button
        }
    }
    
    func setupNewsImageView() {
        shadowView.dropShadow(radius: 5, xOffset: 0, yOffset: 1, shadowOpacity: 0.8, shadowColor: .black)
        newsImageView.layer.cornerRadius = 10
        
        if presenter.news.isSaveNews == true, let data = presenter.news.image {
            title = "Detail news"
            descriptionLabel.text = presenter.news.title
            newsImageView.image = UIImage(data: data)
        } else {
            title = presenter.news.type
            descriptionLabel.text = presenter.news.title
            presenter.news.media?.forEach { media in
                media.mediametadata?.forEach {
                    guard let image = $0.url, let url = URL(string: image) else { return }
                    DispatchQueue.main.async {
                        self.newsImageView.kf.setImage(with: url)
                    }
                }
            }
        }
    }
}

// MARK: - NewsDetailViewController
extension NewsDetailViewController {
    @objc
    private func saveNewsInBase() {
        guard let managedObjectContext = managedObjectContext else {
            fatalError("No Managed Object Context Available")
        }
        
        // Create Book
        let news = NewsEntity(context: managedObjectContext)
        let pngImageData = newsImageView.image?.pngData()
        news.name = presenter.news.title
        news.image = pngImageData
        
        do {
            try managedObjectContext.save()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Unable to Save Book, \(error)")
        }
    }
}
