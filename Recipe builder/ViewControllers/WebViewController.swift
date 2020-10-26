//
//  WebViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 17.10.2020.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet var fullRecipeWebKit: WKWebView!
    
    // MARK: - Let & Var
    var urlFullRecipe: String!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWebsiteInWebView()
    }
    
    // MARK: - Methods
    func fetchWebsiteInWebView () {
        guard let url = URL(string: urlFullRecipe ?? "https://www.foodnetwork.com/recipes/food-network-kitchen/american-meat-sauce-3361490") else { return }
        fullRecipeWebKit.load(URLRequest(url: url))
        fullRecipeWebKit.allowsBackForwardNavigationGestures = true
    }
}

