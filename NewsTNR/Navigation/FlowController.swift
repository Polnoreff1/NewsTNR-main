//
//  FlowController.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit
import CoreData

final class FlowController: UIViewController, UITabBarControllerDelegate {

    private var embedTabBarVC: UITabBarController = UITabBarController()

    private lazy var newsVC: UINavigationController = instantiateNewsVC()
    private lazy var sharedVC: UINavigationController = instantiateSharedNewsVC()
    private lazy var viewedVC: UINavigationController = instantiateViewedNewsVC()
    private lazy var saveNewsVC: UINavigationController = instantiateProfileVC()

    private let navigator = Navigator()
    private let networkService = AlamofireNetwork()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = embedTabBarVC.tabBar.items {
            for item in items {
                item.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                item.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
            }
        }
    }
}

private extension FlowController {

    func initialSetup() {

        view.backgroundColor = .white
        
        let appearance = embedTabBarVC.tabBar.standardAppearance
        appearance.shadowColor = .gray
        embedTabBarVC.tabBar.standardAppearance = appearance
        embedTabBarVC.tabBar.scrollEdgeAppearance = appearance
        embedTabBarVC.delegate = self
        embedTabBarVC.viewControllers = [newsVC, sharedVC, viewedVC, saveNewsVC]
        embedTabBarVC.tabBar.isTranslucent = false
        embedTabBarVC.tabBar.tintColor = .black
        embedTabBarVC.tabBar.unselectedItemTintColor = UIColor.gray
        addChild(embedTabBarVC, toContainer: view)
    }
}

extension FlowController {

    func setSelectedIndex(index: Int) {
        self.embedTabBarVC.selectedIndex = index
    }

    func instantiateNewsVC() -> UINavigationController {
        let presenter = NewsPresenter(navigator: navigator, networkService: networkService)
        let vc: NewsViewController = NewsViewController(presenter: presenter)
        presenter.set(view: vc)
        let navigationVC = UINavigationController(rootViewController: vc)
        let appearance = UINavigationBarAppearance()
        appearance.setDefaultNavBar(color: .gray)
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        
        vc.tabBarItem = UITabBarItem(
            title: "Emailed News", image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane")
        )
        return navigationVC
    }
    
    func instantiateSharedNewsVC() -> UINavigationController {
        let presenter = SharedNewsPresenter(navigator: navigator, networkService: networkService)
        let vc: SharedNewsViewController = SharedNewsViewController(presenter: presenter)
        presenter.set(view: vc)
        let navigationVC = UINavigationController(rootViewController: vc)
        let appearance = UINavigationBarAppearance()
        appearance.setDefaultNavBar(color: .gray)
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        
        vc.tabBarItem = UITabBarItem(
            title: "Shared News", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper")
        )
        return navigationVC
    }
    
    func instantiateViewedNewsVC() -> UINavigationController {
        let presenter = ViewedNewsPresenter(navigator: navigator, networkService: networkService)
        let vc: ViewedNewsViewController = ViewedNewsViewController(presenter: presenter)
        presenter.set(view: vc)
        let navigationVC = UINavigationController(rootViewController: vc)
        let appearance = UINavigationBarAppearance()
        appearance.setDefaultNavBar(color: .gray)
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        
        vc.tabBarItem = UITabBarItem(
            title: "Viewed News", image: UIImage(systemName: "network"), selectedImage: UIImage(systemName: "network")
        )
        return navigationVC
    }

    func instantiateProfileVC() -> UINavigationController {

        let presenter = SaveNewsPresenter(navigator: navigator, networkService: networkService)
        let vc: SaveNewsViewController = SaveNewsViewController(presenter: presenter)
        presenter.set(view: vc)
        let navigationVC = UINavigationController(rootViewController: vc)
        let appearance = UINavigationBarAppearance()
        appearance.setDefaultNavBar(color: .gray)
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        
        vc.tabBarItem = UITabBarItem(
            title: "Save News", image: UIImage(systemName: "mail.stack"), selectedImage: UIImage(systemName: "mail.stack")
        )
        return navigationVC
    }
}
