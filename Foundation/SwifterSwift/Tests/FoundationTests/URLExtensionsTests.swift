// URLExtensionsTests.swift - Copyright 2022 SwifterSwift

@testable import SwifterSwift
import XCTest

#if canImport(Foundation)
    import Foundation

    final class URLExtensionsTests: XCTestCase {
        var url = URL(string: "https://www.google.com")!
        let params = ["q": "swifter swift"]
        let queryUrl = URL(string: "https://www.google.com?q=swifter%20swift")!

        func testQueryParameters() {
            let url = URL(string: "https://www.google.com?q=swifter%20swift&steve=jobs&empty")!
            guard let parameters = url.queryParameters else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(parameters.count, 2)
            XCTAssertEqual(parameters["q"], "swifter swift")
            XCTAssertEqual(parameters["steve"], "jobs")
            XCTAssertNil(parameters["empty"])
        }

        func testOptionalStringInitializer() {
            XCTAssertNil(URL(string: nil, relativeTo: nil))
            XCTAssertNil(URL(string: nil))

            let baseURL = URL(string: "https://www.example.com")
            XCTAssertNotNil(baseURL)
            XCTAssertNil(URL(string: nil, relativeTo: baseURL))

            let string = "/index.html"
            let optionalString: String? = string
            XCTAssertEqual(URL(string: optionalString, relativeTo: baseURL), URL(string: string, relativeTo: baseURL))
            XCTAssertEqual(
                URL(string: optionalString, relativeTo: baseURL)?.absoluteString,
                "https://www.example.com/index.html"
            )
        }

        func testAppendingQueryParameters() {
            XCTAssertEqual(url.appendingQueryParameters(params), queryUrl)
        }

        func testAppendQueryParameters() {
            url.appendQueryParameters(params)
            XCTAssertEqual(url, queryUrl)
        }

        func testValueForQueryKey() {
            let url = URL(string: "https://google.com?code=12345&empty")!

            let codeResult = url.queryValue(for: "code")
            let emtpyResult = url.queryValue(for: "empty")
            let otherResult = url.queryValue(for: "other")

            XCTAssertEqual(codeResult, "12345")
            XCTAssertNil(emtpyResult)
            XCTAssertNil(otherResult)
        }

        func testDeletingAllPathComponents() {
            let url = URL(string: "https://domain.com/path/other/")!
            let result = url.deletingAllPathComponents()
            XCTAssertEqual(result.absoluteString, "https://domain.com/")

            let pathlessURL = URL(string: "https://domain.com")!
            let pathlessResult = pathlessURL.deletingAllPathComponents()
            XCTAssertEqual(pathlessResult.absoluteString, "https://domain.com")
        }

        func testDeleteAllPathComponents() {
            var url = URL(string: "https://domain.com/path/other/")!
            url.deleteAllPathComponents()
            XCTAssertEqual(url.absoluteString, "https://domain.com/")

            var pathlessURL = URL(string: "https://domain.com")!
            pathlessURL.deleteAllPathComponents()
            XCTAssertEqual(pathlessURL.absoluteString, "https://domain.com")
        }

        #if os(iOS) || os(tvOS)
            func testThumbnail() {
                XCTAssertNil(url.thumbnail())

                let videoUrl = Bundle(for: URLExtensionsTests.self)
                    .url(forResource: "big_buck_bunny_720p_1mb", withExtension: "mp4")!
                XCTAssertNotNil(videoUrl.thumbnail())
                XCTAssertNotNil(videoUrl.thumbnail(fromTime: 1))
            }
        #endif

        func testDropScheme() {
            let urls: [String: String?] = [
                "https://domain.com/path/other/": "domain.com/path/other/",
                "https://domain.com": "domain.com",
                "http://domain.com": "domain.com",
                "file://domain.com/image.jpeg": "domain.com/image.jpeg",
                "://apple.com": "apple.com",
                "//apple.com": "apple.com",
                "apple.com": "apple.com",
                "http://": nil,
                "//": "//",
            ]

            urls.forEach { input, expected in
                guard let url = URL(string: input) else { return XCTFail("Failed to initialize URL.") }
                XCTAssertEqual(url.droppedScheme()?.absoluteString, expected, "input url: \(input)")
            }
        }

        func testStringInitializer() throws {
            let testURL = try XCTUnwrap(URL(string: "https://google.com"))
            let extensionURL = URL(unsafeString: "https://google.com")
            XCTAssertEqual(testURL, extensionURL)
        }
    }

#endif
