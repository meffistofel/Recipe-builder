//
//  WebViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 17.10.2020.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var fullRecipeWebKit: WKWebView!
    
    var urlFullRecipe: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(urlFullRecipe!)
    
//let http = URL(string: "http://some.com/example.html")!
        
        
        

        guard let url = URL(string: urlFullRecipe ?? "https://www.foodnetwork.com/recipes/food-network-kitchen/american-meat-sauce-3361490") else { return }
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!
        print(https)
        fullRecipeWebKit.load(URLRequest(url: https))
        fullRecipeWebKit.allowsBackForwardNavigationGestures = true
    }
}
