const fs = require("fs");

fs.readFile("input/Week1/Year2020Day5.sample.txt", "utf8", (err, data) => {
  const dataArray = data
    .toString()
    .split("\n")
    .map((val) => val.split(""));

  const resultArray = result(dataArray);

  const part1 = resultArray.reduce((prev, current) => {
    return prev > current ? prev : current;
  });
  console.log(part1);

  // console.log(part2(resultArray));
});

const result = (array) => {
  return array
    .map((val) => {
      const boardLength = val.length;
      let rowMax = 128;
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
    .sort((a, b) => a - b);
};

const test = (array) => {
  return array
    .map((val) => {
      const rowArray = Array.from({ length: 128 }, (x, i) => i);
      const columnArray = Array.from({ length: 8 }, (x, i) => i);
      return val.map((board) => {
        // column

        const rowHalf = Math.ceil(rowArray.length / 2);
        const columnHalf = Math.ceil(columnArray.length / 2);

        switch (board) {
          case "F":
            rowArray.splice(0, rowHalf);
            break;
          case "B":
            rowArray.splice(rowHalf, rowArray.length);
            break;
          case "R":
            columnArray.splice(columnHalf, columnArray.length);
            break;
          case "L":
            columnArray.splice(0, columnHalf);
            break;
        }
      });
    })
    .sort((a, b) => a - b);
};

const part2 = (array) => {
  for (let i = 0; i < array.length; i++) {
    const currentSeat = array[i];
    if (array[i + 1] === currentSeat + 2) return currentSeat + 1;
  }
};
