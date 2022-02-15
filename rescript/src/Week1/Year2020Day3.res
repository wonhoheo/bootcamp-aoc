type toboggan = {
  mutable column: int,
  mutable row: int,
  mutable trees: int,
}

let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day3.sample.txt")

let pattern = [[3, 1]]

let dataArray = Js.String2.split(input, "\n")->Belt.Array.map(val => Js.String2.split(val, ""))

let part1 = (array, x, y) => {
  let result = {column: 0, row: 0, trees: 0}

  while result.row < array->Js.Array2.length {
    let columnUnit = mod(result.column, array[0]->Js.Array2.length)
    let point = array[result.row][columnUnit]
    Js.log([result.row, columnUnit])
    if point === "#" {
      result.trees = result.trees + 1
    }

    result.column = result.column + x
    result.row = result.row + y
  }
  result.trees
}

part1(dataArray, 3, 1)->Js.log

let part2 = (array, slopes) => {
  slopes
  ->Belt.Array.map(val => {
    part1(array, val[0], val[1])
  })
  ->Belt.Array.reduce(1.0, (prev, current) => prev *. current->Belt.Int.toFloat)
}

// part2(dataArray, pattern)->Js.log
