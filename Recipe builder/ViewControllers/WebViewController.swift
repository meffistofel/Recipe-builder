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
    
//        let escapedString = urlFullRecipe.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
//        print(escapedString!)

        guard let url = URL(string: urlFullRecipe ?? "") else { return }
        fullRecipeWebKit.load(URLRequest(url: url))
        fullRecipeWebKit.allowsBackForwardNavigationGestures = false
    }
}
