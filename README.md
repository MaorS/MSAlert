# MSAlert
##### Simple and super easy to use of native UIAlertController

## Installation

### Manually
Drag and drop MSAction.swift and Assets into your project


## Usage

#### Initializate MSAlert object

Empty MSAlert object
```swift
MSAlert(viewController: self, sourceView: sender)
```

Or with title and message

```swift
MSAlert(viewController: self, sourceView: sender, title: "Your Title", message: "Your message")
```

#### Add alert actions

Simple alert action from `MSActionType enum`
```swift
.add(.ok)
```
Custom alert action title
```swift
.add(.cancel, title: "custom title")
```
Custom alert action style
```swift
.add(.cancel, title: "custom title", style: .destructive)
```
Custom alert action image
```swift
.add(.cancel, title: "custom title", style: .destructive, image: my_image)
```

Use the default image of `MSActionType enum`
```swift
.add(.cancel, title: "custom title", style: .destructive, defaultImage : true)
```

#### Add custom alert actions

```swift
.add(title: "Accept"){
// completion on click
}
```
customized:
```swift
.add(title: "Accept", isDestructive: false, image: my_image){
// completion on click
}
```

#### Set alert sound

```swift
.setSound(from: myURL)
```


#### Set tint color

```swift
.setTint(color: .purple)
```

#### Show the alert
```swift
.show()
```
#### Show the alert with completion handler
```swift
.show { didPress in
  // on click of alert action

  if didPress == .ok{
    // do some
  }
}
```
# License
MSAlert is available under the MIT license. See the LICENSE file for more info.
