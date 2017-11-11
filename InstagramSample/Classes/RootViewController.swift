//
//  RootViewController.swift
//  InstagramSample
//
//  Created by Kosuke Matsuda on 2017/11/11.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    var viewAppearFirst = true
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldAuth() {
            performSegue(withIdentifier: "ShowAuth", sender: self)
            viewAppearFirst = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuth",
            let navi = segue.destination as? UINavigationController,
            let auth = navi.viewControllers.first as? AuthViewController
        {
            auth.delegate = self
        }
    }

    func shouldAuth() -> Bool {
        return viewAppearFirst && accessToken == nil
    }

    func request() {
        guard let token = accessToken else {
            return
        }

        let mediaURL = Instagram.buildURL(endpoint: .selfRecent, parameters: ["access_token": token])
        print("URL >>>", mediaURL)

        let task = URLSession.shared.dataTask(with: mediaURL) { (data, response, error) in
            guard let data = data else { return }
            let text = String(data: data, encoding: .utf8)
            print(text ?? "")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                print(json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

extension RootViewController: AuthViewControllerDelegate {
    func authViewController(authViewController: AuthViewController, didAuthenticate token: String) {
        accessToken = token
        authViewController.dismiss(animated: true) { [unowned self] in
            self.request()
        }
    }
}
