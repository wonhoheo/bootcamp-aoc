const fs = require("fs");

fs.readFile("input/Week1/Year2020Day5.sample.txt", "utf8", (err, data) => {
  let dataArray = data.toString().split("\n");

  let result = median(
    dataArray.map((val) => {
      let boardLength = val.length;
      let rowMax = 127;
      let columnMax = 8;
      let column = 0;
      let row = 0;

      let i = 0;
      while (i < boardLength) {
        let rowHalf = Math.ceil((row + rowMax) / 2);
        let columnHalf = Math.ceil((column + columnMax) / 2);

        switch (val[i]) {
          case "F":
            rowMax = rowHalf;
            break;
          case "B":
            row = rowHalf;
            break;
          case "R":
            column = columnHalf;
            break;
          case "L":
            columnMax = columnHalf;
            break;
        }
        i++;
      }
      return row * 8 + column;
    })
  );
  // .reduce((previous, current) => {
  //   return previous > current ? previous : current;
  // });
  console.log(result);
});

const median = (arr) => {
  let middle = Math.floor(arr.length / 2);
  arr = [...arr].sort((a, b) => a - b);
  return arr.length % 2 !== 0
    ? arr[middle]
    : (arr[middle - 1] + arr[middle]) / 2;
};
