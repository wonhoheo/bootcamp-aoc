// part1

let input = Node.Fs.readFileAsUtf8Sync("input/Week2/Year2020Day2.sample.txt")
type contains = (int, int)
type password = {
  min: int,
  max: int,
  letter: string,
  password: array<string>,
}

let strToArray = str => {
  let reg = %re("/\:/gi")
  let x1 = str->Js.String2.split("\n")->Belt.Array.map(val => val->Js.String2.split(" "))

  x1->Belt.Array.map(x => x->Belt.Array.map(y => y->Js.String2.replaceByRe(reg, "")))
}

let convertContains = v => {
  let x1 = v->Js.String2.split("-")->Belt.Array.map(x => x->Belt.Int.fromString)
  switch x1 {
  | [Some(a), Some(b)] => Some(a, b)
  | _ => None
  }
}

let parsePassword = value => {
  switch value {
  | [contains, letter, password] =>
    convertContains(contains)->Belt.Option.map(((min, max)) => {
      min: min,
      max: max,
      letter: letter,
      password: password->Js.String2.split(""),
    })

  | _ => None
  }
}
let part1 = v => {
  let letterCount = v.password->Belt.Array.keep(x => x === v.letter)->Belt.Array.length
  v.min <= letterCount && v.max >= letterCount
}

let part2 = v => {
  let count =
    v.password
    ->Belt.Array.keepWithIndex((_v, i) => i == v.min - 1 || i == v.max - 1)
    ->Belt.Array.keep(x => x === v.letter)
    ->Belt.Array.length

  count === 1
}
let f = part => {
  input->strToArray->Belt.Array.keepMap(parsePassword)->Belt.Array.keep(part)->Belt.Array.length
}
part1->f->Js.log
part2->f->Js.log
