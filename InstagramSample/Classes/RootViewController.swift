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
    lazy var accessToken: String? = Store.shared.accessToken
    var dataSource: InstagramResponse.UserRecent?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldAuth() {
            performSegue(withIdentifier: "ShowAuth", sender: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !shouldAuth() {
//            request()
            requestLocally()
        }
        viewAppearFirst = false
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

        let task = URLSession.shared.dataTask(with: mediaURL) { [weak self] (data, response, error) in
            guard let data = data else { return }
            self?.resultDump(data: data)
            self?.dataSource = try? JSONDecoder().decode(InstagramResponse.UserRecent.self, from: data)
        }
        task.resume()
    }

    func resultDump(data: Data) {
        guard let text = String(data: data, encoding: .utf8) else {
            return
        }
        print(text)
        if let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            try? text.write(toFile: "\(path)/media_recent.json", atomically: true, encoding: .utf8)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            print(json)
        } catch {
            print(error)
        }
    }

    func requestLocally() {
        guard let data = try? InstagramResponse.load(sample: .media_recent) else {
            return
        }
        dataSource = try? JSONDecoder().decode(InstagramResponse.UserRecent.self, from: data)
        print(dataSource ?? "")
    }
}

extension RootViewController: AuthViewControllerDelegate {
    func authViewController(authViewController: AuthViewController, didAuthenticate token: String) {
        Store.shared.accessToken = token
        accessToken = token
        authViewController.dismiss(animated: true) { [unowned self] in
            self.request()
        }
    }
}
