/*:
 ## Exercise - Type Casting and Inspection
 
 Create a collection of type [Any], including a few doubles, integers, strings, and booleans within the collection. Print the contents of the collection.
 */
let anyCollection: [Any] = [10.5, 20, "testing", true]
print(anyCollection[0])
print(anyCollection[1])
print(anyCollection[2])
print(anyCollection[3])
/*:
 Loop through the collection. For each integer, print "The integer has a value of ", followed by the integer value. Repeat the steps for doubles, strings and booleans.
 */
for item in anyCollection {
  if item is Double {
    print("Double: \(item)")
  } else if item is Int {
    print("Integer: \(item)")
  } else if item is String {
    print("Strings: \(item)")
  } else if item is Bool {
    print("booleans: \(item)")
  } else {
    print("Other type: \(item)")
  }
}
/*:
 Create a [String : Any] dictionary, where the values are a mixture of doubles, integers, strings, and booleans. Print the key/value pairs within the collection
 */
var anyDictionary: [String: Any] = ["Double": 10.5, "Integer": 20, "String": "10", "Booleans": false]
for item in anyDictionary {
  print("\(item.key) = \(item.value)")
}
/*:
 Create a variable `total` of type `Double` set to 0. Then loop through the dictionary, and add the value of each integer and double to your variable's value. For each string value, add 1 to the total. For each boolean, add 2 to the total if the boolean is `true`, or subtract 3 if it's `false`. Print the value of `total`.
 */
var total: Double = 0
for item in anyDictionary {
  if let i = item.value as? Int {
    total += Double(i)
  } else if let d = item.value as? Double {
    print("d=\(d)")
    total += d
  } else if item.value is String {
    total += 1
  } else if let b = item.value as? Bool {
    if b {
      total += 2
    } else {
      total -= 3
    }
  }
}
print("Total=\(total)")
/*:
 Create a variable `total2` of type `Double` set to 0. Loop through the collection again, adding up all the integers and doubles. For each string that you come across during the loop, attempt to convert the string into a number, and add that value to the total. Ignore booleans. Print the total.
 */
var total2: Double = 0
for item in anyDictionary {
  if let i = item.value as? Int {
    total2 += Double(i)
  } else if let d = item.value as? Double {
    total2 += d
  } else if let s = item.value as? String {
    if let s = Double(s) {
      total2 += s
    }
  }
}
print("Total2=\(total2)")
//: page 1 of 2  |  [Next: App Exercise - Workout Types](@next)
