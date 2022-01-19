const fs = require("fs");

const type = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
];

fs.readFile("input/Week1/Year2020Day3.sample.txt", "utf8", (err, data) => {
  let map = data.toString().split("\n");
  const treeCounts = type
    .map(([right, down]) => {
      let column = 0;
      let row = 0;

      const rowMax = map.length - 1;
      const columnMax = map[row].length - 1;
      let trees = 0;

      while (row < rowMax) {
        column += right;

        if (column > columnMax) {
          column -= columnMax + 1;
        }

        row += down;

        if (map[row][column] === "#") {
          trees++;
        }
      }
      return trees;
    })
    .reduce((previousValue, currentValue) => {
      return previousValue * currentValue;
    });
  console.log(treeCounts);
});
