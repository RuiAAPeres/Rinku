# Rinku (リンク)
**A beautifully simple networking library**

The purpose of Rinku ("link" in japanese) is to allow the user to established a connection/link to the outside world, via  `NSURLSession`. The main goals while developing it were:

* Minimalism
* Composability
* Simplicity

## Usage

The most basic case would be with a GET:

```swift
Rinku.get("http://myservice.com/").withCompletion({completion in

})
```

The `completion` parameter is a tuple `(NSData!, NSURLResponse!, NSError!)`. You can as well `POST` data:

```swift
Rinku.post("http://myservice.com/").withBody(image).withCompletion({completion in

})
```

## Actions 

The currents actions are part of this version:

* Add an HTTP Headers
* Add an HTTP Body
* Add a completion block

A lot is covered with these basic actions, but more will be available soon. 