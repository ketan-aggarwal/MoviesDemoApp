//
//  InfoViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 11/12/23.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    var webView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.frame = view.bounds    
        loadHTMLContent()
        navigationItem.rightBarButtonItem = nil
    }

    @objc func openSideMenu() {
        if let parent = parent as? MovieViewController {
            parent.present(parent.sideMenu!, animated: true)
        }
    }
    
    private func loadHTMLContent() {
        if webView == nil {
            webView = WKWebView(frame: view.bounds)
            view.addSubview(webView!)
        }
        if let filePath = Bundle.main.path(forResource: "movies_app", ofType: "html"),
            let fileContents = try? String(contentsOfFile: filePath) {
            webView?.loadHTMLString(fileContents, baseURL: Bundle.main.bundleURL)
        }
    }
}
