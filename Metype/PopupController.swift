//
//  PopupController.swift
//  Metype
//
//  Created by Pavan Gopal on 10/13/17.
//  Copyright © 2017 Albin.git. All rights reserved.
//

import UIKit
import WebKit

class PopupController: UIViewController,WKUIDelegate {
    
    var popWebview:WKWebView?
    var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    func loadWebView(configuration:WKWebViewConfiguration){
        
        popWebview = WKWebView(frame: self.view.frame, configuration: configuration)
        popWebview?.uiDelegate = self
        
        view.addSubview((popWebview)!)
        popWebview?.fillSuperview()
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        view.addSubview(progressView)
        
        progressView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 2)
        
        popWebview?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float((popWebview?.estimatedProgress) ?? 0)
            print(Float((popWebview?.estimatedProgress) ?? 0))
            
        }
    }
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if (navigationAction.targetFrame == nil) {
            let popUpVC = PopupController()
            let navVC = UINavigationController(rootViewController: popUpVC)
            popUpVC.loadWebView(configuration: configuration)
            
            self.navigationController?.present(navVC, animated: true, completion: nil)
            
            return (popUpVC.popWebview)!
        }
        
        return nil;
        
    }
    
    deinit {
        print("deinit called")
        
        popWebview?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
}

