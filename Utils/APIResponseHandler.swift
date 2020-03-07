//
//  APIResponseHandler.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 07/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct ResponseHandler {
    func handle(data: Data?, response: URLResponse?, error: Error?) throws {
        if let error = error {
            #if DEBUG
            print("🛑 - \((error as NSError).code) - \(response?.url?.path ?? "No response")")
            #endif
            throw APIError.device(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            if response != nil {
                #if DEBUG
                print("🗄 - \(response?.url?.path ?? "N/A")")
                #endif
                return
            }

            #if DEBUG
            print("🛑 - unknown response - \(response?.url?.path ?? "No response")")
            #endif
            throw APIError.unknownResponseType
        }

        guard 200...299 ~= httpResponse.statusCode || httpResponse.statusCode == 304 else {
            #if DEBUG
            print("🛑 - \(httpResponse.statusCode) - \(httpResponse.url?.path ?? "N/A")")
            #endif
            throw APIError.unknownResponseType
        }
        #if DEBUG
        print("✅ - \(httpResponse.url?.path ?? "N/A")")
        #endif
    }

    func read(data: Data?) throws -> Data {
        guard let data = data else {
            throw APIError.noData
        }
        return data
    }
}
