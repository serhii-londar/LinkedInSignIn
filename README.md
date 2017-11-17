# LinkedInSignIn

[![CI Status](http://img.shields.io/travis/serhii-londar/LinkedInSignIn.svg?style=flat)](https://travis-ci.org/serhii-londar/LinkedInSignIn)
[![Version](https://img.shields.io/cocoapods/v/LinkedInSignIn.svg?style=flat)](http://cocoapods.org/pods/LinkedInSignIn)
[![License](https://img.shields.io/cocoapods/l/LinkedInSignIn.svg?style=flat)](http://cocoapods.org/pods/LinkedInSignIn)
[![Platform](https://img.shields.io/cocoapods/p/LinkedInSignIn.svg?style=flat)](http://cocoapods.org/pods/LinkedInSignIn)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Also you need to setup app on [LinkedIn](https://www.linkedin.com/developer/apps) and fill in dictionary with your app credetials:

```swift
let linkedinCredentilas = [
    "linkedInKey": "",
    "linkedInSecret": "",
    "redirectURL": ""
]

```

Login proces is simple as:

```swift
let linkedInConfig = LinkedInConfig(linkedInKey: linkedinCredentilas["linkedInKey"]!, linkedInSecret: linkedinCredentilas["linkedInSecret"]!, redirectURL: linkedinCredentilas["redirectURL"]!)
let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)
linkedInHelper.login(from: self, completion: { (accessToken) in
        let alertVC = UIAlertController(title: "Success", message: "Your access token is : \(accessToken)!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }))
    self.present(alertVC, animated: true, completion: nil)
}) { error in
    print(error.localizedDescription)
}
```

<p align="center">
  <img src="https://i.imgur.com/R8haoKu.png" width="350"/>
</p>

<p align="center">
  <img src="https://i.imgur.com/QzjcjDR.png" width="350"/>
</p>


<!--## Requirements
-->


## Installation

LinkedInSignIn is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LinkedInSignIn'
```

## Author

Github: [Serhii Londar](https://github.com/serhii-londar)

Email: [serhii.londar@gmail.com](mailto:serhii.londar@gmail.com)

## License

LinkedInSignIn is available under the MIT license. See the LICENSE file for more info.
