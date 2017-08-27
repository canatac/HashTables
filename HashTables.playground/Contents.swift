//: Playground - noun: a place where people can play

import Foundation

public struct HashTable<Key: Hashable, Value> {
 private typealias Element = (key: Key, value: Value)
 private typealias Bucket = [Element]
 private var buckets: [Bucket]

 private(set) public var count = 0

 public var isEmpty: Bool { return count == 0 }

 public init(capacity: Int) {
  assert(capacity > 0)
  buckets = Array<Bucket>(repeatElement([], count: capacity))
 }

 private func index(forKey key: Key) -> Int {
  return abs(key.hashValue) % buckets.count
 }

 public subscript(key: Key) -> Value? {
  get {
   return value(forKey: key)
  }
  set {
   if let value = newValue {
    updateValue(value, forKey: key)
   } else {
    removeValue(forKey: key)
   }
  }
 }

 public func value(forKey key: Key) -> Value? {
  let index = self.index(forKey: key)
  for element in buckets[index] {
   if element.key == key {
    return element.value
   }
  }

   return nil
   // key not in hash table
 }

 public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
  let index = self.index(forKey: key)
  // Do we already have this key in the bucket?
  for (i, element) in buckets[index].enumerated() {
   if element.key == key {
    let oldValue = element.value
    buckets[index][i].value = value
    return oldValue
   }
  }
  // This key isn't in the bucket yet; add it to the chain.
  buckets[index].append((key: key, value: value))
  count += 1
  return nil
 }

 public mutating func removeValue(forKey key: Key) -> Value? {
  let index = self.index(forKey: key)

  // Find the element in the bucket's chain and remove it.
  for (i, element) in buckets[index].enumerated() {
   if element.key == key {
    buckets[index].remove(at: i)
    count -= 1
    return element.value
   }
  }
  return nil  // key not in hash table
 }
}



var m = "6" // nb of words in the magazine
var n = "5" // nb of words in the ransom note

var line1 = "two times three is not four"
var line2 = "two times two is four"
let intM = Int(m)!
let intN = Int(n)!
var hashTable1 = HashTable<String, String>(capacity: intM)
var hashTable2 = HashTable<String, String>(capacity: intN)

var arr1 = [String](repeatElement(String(), count: intM))
var arr2 = [String](repeatElement(String(), count: intN))

arr1 = line1.characters.split(separator: " ").map({String($0)})
arr2 = line2.characters.split(separator: " ").map({String($0)})


// COUNT NB OF SAME WORD

arr1.forEach({element in
 guard let element1 = hashTable1[element] else {
  hashTable1[element] = "1"
  return
 }
  hashTable1[element] = String(Int(hashTable1[element]!)! + 1)
})

arr2.forEach({element in
 guard let element2 = hashTable2[element] else {
  hashTable2[element] = "1"
  return
 }
 hashTable2[element] = String(Int(hashTable2[element]!)! + 1)
})
var isOk = false

var i = 0
for i in 0..<intN {
 let word = arr2[i]
 guard let word1 = hashTable1[word] else {
  isOk = false
  break
 }

 if Int(hashTable1[word]!)! >= Int(hashTable2[word]!)! {
  isOk = true
 }else{
  isOk = false
  break
 }
}


print(isOk ? "Yes":"No")