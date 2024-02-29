![Rumble: Abstracted MVVM Clean Architecture (Domain Use cases & Data) library written in Swift.]("https://")

[![Swift](https://img.shields.io/badge/Swift-5.7_5.8_5.9-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.7_5.8_5.9-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS-Green?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

Rumble is an Abstracted MVVM Clean Architecture (Domain Use cases & Data) library written in Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contributing](#contributing)

## Features

- [x] Network & Database Property Wrapper
- [x] Upload File ( Coming soon)
- [x] Download File (Coming soon)
- [x] SSL Pinning
- [x] Biometric Touch & Face ID
- [x] Dynamically saving & injecting sensisitive data from response to http headers respectively.
- [x] UserDefaults property wrapper for both Objects (Codable) & Literals (Int,  Bool, String, Array, Dictionary)
- [x] SQLQuery DSL (coming soon)

## Write Usecases / Business logics Fast!

```swift
import Rumble


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let configuration = Rumble.Configuration.init(authenticatedKey: "Authorization", headers: HTTPClient_Ex.getHeaders())
        RetailerCoreSDK.sdk.configuration = configuration
        
        KeychainInterface.reset()
        return true
    }
}

struct HTTPClient_Ex {
    private init() {}
    
    static func getHeaders() -> HTTPClient.HTTPHeaders {
        var headers = HTTPClient.HTTPHeaders()
        return headers
    }
}
```

```swift

class OtherEntity: NSManagedObject, Value {}

protocol SampleUsecase {
    func execute() async throws
}

class DefaultSampleUsecaseUsecase: BaseUsecase, SampleUsecase {
    @UserDefaultsObject(key: SomeKeys.profile) var profile: Profile?
    @UserDefaultsLitaral(key: SomeKeys.username) var username: String?
    
    @DatabaseCRUDWrapper<DemoEntity> public var otherEntityCRUD
    
    func execute() {
        let url = "...."
        
        let response: SampleResponse = try await network.load(url: url)
        
        guard let data = response.data else {
            throw Exceptions.error("Something went wrong before fetching this request. please try again later.")
        }
        
        profile = response?.data?.profile
        username = response?.data?.profile?.userName
        
        
        
        let query = DefaultSQLQuery()
        query
            .equal(key: "id", value: 1)
            .equal(key: "type", value: "pro")
    
        let result = try? await otherEntityCRUD.load(query: query) as? Fetched<DemoEntity>
        print(result)
    }
}
```

## Requirements

| Platform                                             | Minimum Swift Version | Installation                                                                                                         | Status                   |
| ---------------------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| iOS 15.0+ / macOS 10.15+                             | 5.7 / Xcode 15.2            | [Swift Package Manager](#swift-package-manager)                                                                      | Fully Tested             |



## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Rumble as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/i-am-deoye/Rumble.git", .upToNextMajor(from: "1.0.0"))
]
```

