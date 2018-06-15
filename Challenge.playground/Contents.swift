//: Playground - noun: a place where people can play

import UIKit

class Cache<K: Equatable&Hashable, V> {
  
  // MARK: - Properties
  private var cache: [K: (V, Date)] = [:]
  private var maxSize = Int()
  
  var description: String {
    get {
      let result = cache.values.compactMap { $0.0 as? String }.joined(separator: ", ")
      return result
    }
  }
  
  // MARK: - Initializers
  init(maxSize: Int) {
    self.maxSize = maxSize
  }
  
  // MARK: - Subscripts
  subscript(key: K) -> V? {
    get { return get(for: key) }
    set (value) {
      if let value = value {
        set(value, for: key)
      } else {
        remove(by: key)
      }
    }
  }
  
  // MARK: - Public Methods
  func get(for key: K) -> V? {
    return cache[key]?.0
  }
  
  func set(_ value: V, for key: K) {
    cache.updateValue((value, Date()), forKey: key)
    if maxSize > Int() && cache.keys.count > maxSize {
      removeOldestItem()
    }
  }
  
  func remove(by key: K) {
    cache.removeValue(forKey: key)
  }
  
  func clear() {
    cache.removeAll()
  }
  
  func contains(key: K) -> Bool {
    return cache.keys.contains(key)
  }
  
  func count() -> Int {
    return cache.count
  }
  
  // MARK: - Private Methods
  private func removeOldestItem() {
    let oldest = cache.keys.reduce(nil) { (oldestKey, key) -> K? in
      if let oldestKey = oldestKey,
        let oldestDate = cache[oldestKey]?.1,
        let keyDate = cache[key]?.1 {
        return keyDate < oldestDate ? key : oldestKey
      } else {
        return key
      }
    }
    guard let key = oldest else { return }
    remove(by: key)
  }
}

enum Song {
  case linkPark
  case greenDay
  case imagineDragons
  case ozzy
}

let cache = Cache<Song, String>(maxSize: 3)

// Adding an asset
cache[Song.linkPark] = "linkpark.mp3"
print(cache.description)

// Adding another asset
cache[Song.greenDay] = "greenday.mp3"
print(cache.description)

// Retrieving an asset
let linkParkAsset = cache[.linkPark] ?? String()
print(linkParkAsset)

// Adding another asset
cache[Song.imagineDragons] = "imaginedragons.mp3"
print(cache.description)

// Adding another asset (at max capacity)
cache[Song.ozzy] = "ozzy.mp3"
print(cache.description)

// Removing an asset
cache[Song.ozzy] = nil
print(cache.description)
