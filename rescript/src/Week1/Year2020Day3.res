let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day3.sample.txt")

let pattern = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

let map = Js.String.split("\n", input)

let treeCounts =
  pattern
  ->Belt_Array.map(([right, down]) => {
    let column = ref(0)
    let row = ref(0)

    let rowMax = map->Js.Array2.length - 1
    let columnMax = map[row.contents]->Js.String.length - 1
    let trees = ref(0)

    while row.contents < rowMax {
      column := column.contents + right

      if column.contents > columnMax {
        column := column.contents - (columnMax + 1)
      }

      row := row.contents + down

      if map[row.contents]->Js.String2.get(column.contents) === "#" {
        trees := trees.contents + 1
      }
    }

    trees
  })
  ->Belt_Array.reduce(1.0, (prev, current) => prev *. current.contents->Belt.Int.toFloat)

Js.log(treeCounts)