/*:
 ## Exercise - Failable Initializers
 
 Create a `Computer` struct with two properties, `ram` and `yearManufactured`, where both parameters are of type `Int`. Create a failable initializer that will only create an instance of `Computer` if `ram` is greater than 0, and if `yearManufactured` is greater than 1970, and less than 2017.
 */
struct Computer {
  var ram: Int
  var yearManuFactured: Int
  
  init?(ram: Int, yearManuFactured: Int) {
    if ram > 0 && yearManuFactured > 1970 && yearManuFactured < 2017 {
      self.ram = ram
      self.yearManuFactured = yearManuFactured
    } else {
      return nil
    }
  }
}
/*:
 Create two instances of `Computer?` using the failable initializer. One instance should use values that will have a value within the optional, and the other should result in `nil`. Use if-let syntax to unwrap each of the `Computer?` objects and print the `ram` and `yearManufactured` if the optional contains a value.
 */
let computer1 = Computer(ram: 100, yearManuFactured: 2000)
let computer2 = Computer(ram: 100, yearManuFactured: 2023)

if let computer = computer1 {
  print("Computer1: \(computer)")
} else {
  print("Computer1: NIL")
}
if let computer = computer2 {
  print("Computer2: \(computer)")
} else {
  print("Computer2: NIL")
}

//: [Previous](@previous)  |  page 5 of 6  |  [Next: App Exercise - Workout or Nil](@next)
