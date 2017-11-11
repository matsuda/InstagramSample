//
//  AuthViewController.swift
//  InstagramSample
//
//  Created by Kosuke Matsuda on 2017/11/11.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate {
    func authViewController(authViewController: AuthViewController, didAuthenticate token: String)
}

/**
 http://www.iostutorialjunction.com/2017/03/Integrate-instagram-login-in-iOS-app-using-Swift3-Tutorial.html
 https://qiita.com/sinpey_g2/items/009180659d9970876284
 */
final class AuthViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var delegate: AuthViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        let url = Constants.Instagram.AuthURL
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func didAuthenticate(token: String) {
        delegate?.authViewController(authViewController: self, didAuthenticate: token)
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let token = accessTokenForCallbackURL(request: navigationAction.request) {
            print("Token :", token)
            decisionHandler(.cancel)
            DispatchQueue.main.async {
                self.didAuthenticate(token: token)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    /**
     url : https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=token
     url : https://www.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=token
     url : https://www.instagram.com/accounts/login/?force_classic_login=&next=/oauth/authorize/%3Fclient_id%3DCLIENT-ID%26redirect_uri%3DREDIRECT-URI%26response_type%3Dtoken
     url : https://www.instagram.com/accounts/login/?force_classic_login=&next=/oauth/authorize/%3Fclient_id%3DCLIENT-ID%26redirect_uri%3DREDIRECT-URI%26response_type%3Dtoken
     url : https://www.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=token
     url : REDIRECT-URI/#access_token=ACCESS-TOKEN
     */
    func accessTokenForCallbackURL(request: URLRequest) -> String? {
        guard let urlString = request.url?.absoluteString else {
            return nil
        }
        print("url :", urlString)
        if urlString.hasPrefix(Constants.Instagram.RedirectUri) {
            guard let range = urlString.range(of: "#access_token=") else {
                return nil
            }
            return String(urlString[range.upperBound...])
        }
        return nil
    }
}
