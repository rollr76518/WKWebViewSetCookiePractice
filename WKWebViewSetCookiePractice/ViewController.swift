//
//  ViewController.swift
//  WKWebViewSetCookiePractice
//
//  Created by Ryan on 2020/8/17.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import UIKit
import WebKit

fileprivate extension HTTPCookie {
  convenience init?(httpbinCookieWithName name: String, value: String) {
    self.init(properties: [
      .path: "/",
      .name: name,
      .value: value,
      .originURL: "https://httpbin.org/cookies",
    ])
  }
}

class ViewController: UIViewController {
	
	private lazy var webView: WKWebView = {
		let webConfiguration = WKWebViewConfiguration()
		return WKWebView(frame: .zero, configuration: webConfiguration)
	}()
	
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .white
		
		view.addSubview(webView)
		webView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.leftAnchor.constraint(equalTo: view.leftAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			webView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
		
		self.view = view
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		HTTPCookieStorage.shared.removeCookies(since: .init(timeIntervalSince1970: 0))
		if let cookie = HTTPCookie(httpbinCookieWithName: "answer", value: "42") {
			HTTPCookieStorage.shared.setCookie(cookie)
		}
		if let cookie = HTTPCookie(httpbinCookieWithName: "key", value: "value") {
			HTTPCookieStorage.shared.setCookie(cookie)
		}
		webView.setAllCookies { [unowned self] in
			NSLog("All cookies have been set!")
			if let url = URL(string: "https://httpbin.org/cookies") {
				self.webView.load(URLRequest(url: url))
			}
		}
	}
}
