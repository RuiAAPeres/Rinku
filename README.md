# Rinku (リンク)
**A simple networking library**

The purpose of Rinku ("link" in japanese) is to allow the user to established a connection/link to the outside world, via  `NSURLSession`. The main goal while developing it were:

* Simplicity: There isn't a lot going on here.

This networking library has borrowed ideas mainly from [here](https://github.com/chriseidhof/github-issues), but also from [here](https://github.com/Alamofire/Alamofire/). 

###Usage

Rinku is composed by 3 main entities:

* **RinkuNetworkTask.swift**: Private struct to keep track of the upload/download and completion/failure/progress handlers.
* **RinkuResource.swift**: Publicaly available and used as a facilitator to carry information regarding the kind of request to be done.
* **RinkuSession.swift**: The main class. Internally uses a `NSURLSession` to make a connection.

