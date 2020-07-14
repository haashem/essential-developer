//
//  URLSessionHTTPClientTest.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 7/14/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { (_, _, _) in
            
        }.resume()
    
    }
}
class URLSessionHTTPClientTest: XCTestCase {

    
    func test_getFromUrl_createsDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    func test_getFromUrl_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCount,1)
    }
    
    // MARK: Helpers
    
    private class URLSessionSpy: URLSession {
        
        var receivedURLs = [URL]()
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task;
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return stubs[url] ??  FakeURLSessionDataTask();
        }
    }
    
    class FakeURLSessionDataTask: URLSessionDataTask {}
    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCount = 0
        
        override func resume() {
            resumeCount += 1
        }
    }
}
