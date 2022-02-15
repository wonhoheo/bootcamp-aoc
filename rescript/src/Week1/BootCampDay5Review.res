// ----- 문제 읽어오기 -----
let text = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day6.sample.txt")

let plus = (x, y) => x + y
let sum = xs => xs->Belt.Array.reduce(0, (total, curr) => plus(total, curr))
// xs :: [1,2,3,4]
// 0 + (1 + 2 + 3 + 4)
// plus(plus(plus(0, 1), 2), 3)

// xs :: []
// 0

let mult = xs => xs->Belt.Array.reduce(1, (total, curr) => total * curr)

let initSet = Js.String2.split("abcdefghijklmnopqrstuvwxyz", "")->Belt.Set.String.fromArray

// multiLineToSet :: String => Belt.Set.String
let f = (str, init, op) => {
  str
  ->Js.String2.split("\n")
  ->Belt.Array.map(s => Js.String2.split(s, ""))
  ->Belt.Array.map(arr => Belt.Set.String.fromArray(arr)) //array<set<string>>
  ->Belt.Array.reduce(init, (prev, current) => op(prev, current))
}

// | = union
// a | a | b | c | d => abcd
let multiLineToSet = str => str->f([]->Belt.Set.String.fromArray, Belt.Set.String.union)

let multiLineToSet2 = str => str->f(initSet, Belt.Set.String.intersect)

let allToGroup = str => {
  str->Js.String2.split("\n\n")
}

let program = (input, f) => {
  allToGroup(input)->Belt.Array.map(f)->Belt.Array.map(Belt.Set.String.size)->sum
}

let part1 = input => {
  program(input, multiLineToSet)->Js.log
}

let part2 = input => {
  program(input, multiLineToSet2)->Js.log
}

part1(text)
part2(text)
