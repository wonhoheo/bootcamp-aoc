/* MyFile.res */
let rec fib = n => {
  switch n {
  | 0 | 1 => 1
  | n => fib(n - 1) + fib(n - 2)
  }
}
Js.log(fib(3))

type myResponse =
  | Yes
  | No
  | PrettyMuch

let areYouCrushingIt = Yes

type red = [#Ruby | #Redwood | #Rust]
type blue = [#Sapphire | #Neon | #Navy]

// Contains all constructors of red and blue.
// Also adds #Papayawhip
type color = [red | blue | #Papayawhip]

let myColor: color = #Ruby

let render = myColor => {
  switch myColor {
  | #blue => Js.log("Hello blue!")
  | #green => Js.log("Hello green!")
  // works!
  | #yellow => Js.log("Hello yellow!")
  }
}