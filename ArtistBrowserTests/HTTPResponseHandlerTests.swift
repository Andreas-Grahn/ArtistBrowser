//
//  HTTPResponseHandlerTests.swift
//  ArtistBrowserTests
//
//  Created by Andreas Grahn on 08/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation
import XCTest
@testable import ArtistBrowser

final class HTTPResponseHandlerTests: XCTestCase {
    private let responseHandler = ResponseHandler()
    func testHandle_withNilResponseAndNilError_shouldThrowUnknownType() {
        do {
            try responseHandler.handle(data: nil, response: nil, error: nil)
            XCTFail()
        } catch let error as APIError {
            guard case APIError.unknownResponseType = error else {
                XCTFail()
                return
            }
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }

    func testHandle_WithInteralServerError_shouldThrowUnknownType() {
        let url = URL(string: "https://api.deezer.com/")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            try responseHandler.handle(data: nil, response: response, error: nil)
            XCTFail()
        } catch let error as APIError {
            guard case APIError.unknownResponseType = error else {
                XCTFail()
                return
            }
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }

    func testHandle_withNilResponse_shouldThrowDeviceError() {
        let error = NSError(domain: "TESTERROR", code: -1, userInfo: nil)
        do {
            try responseHandler.handle(data: nil, response: nil, error: error)
        } catch let error as APIError {
            guard case APIError.device(_) = error else {
                XCTFail()
                return
            }
        } catch {
            XCTFail()
        }
    }

    func testHandle_withOKResponse_shouldNotThrow() {
        let url = URL(string: "https://api.deezer.com/")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        do {
            try responseHandler.handle(data: nil, response: response, error: nil)
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }
}
