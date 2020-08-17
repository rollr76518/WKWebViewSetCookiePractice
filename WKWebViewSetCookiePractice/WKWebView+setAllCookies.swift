//
//  WKWebView+setAllCookies.swift
//  WKWebViewSetCookiePractice
//
//  Created by Ryan on 2020/8/17.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import WebKit

extension WKWebView {

	func setAllCookies(completion: @escaping () -> Void) {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
		queue.name = "setAllCookies"
		
		DispatchQueue.global().async {
			HTTPCookieStorage.shared.cookies?.forEach { cookie in
				let operation = BlockOperation {
					let semaphore = DispatchSemaphore(value: 0)
					DispatchQueue.main.async { [weak self] in
						guard let self = self else {
							semaphore.signal()
							return
						}
						self.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
							semaphore.signal()
						}
					}
					semaphore.wait()
				}
				queue.addOperation(operation)
			}
			queue.waitUntilAllOperationsAreFinished()
			DispatchQueue.main.async {
				completion()
			}
		}
	}
}
