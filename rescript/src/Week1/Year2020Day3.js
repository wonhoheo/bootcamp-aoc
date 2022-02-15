const fs = require("fs");

const type = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
];

fs.readFile("input/Week1/Year2020Day3.sample.txt", "utf8", (err, data) => {
  const dataArray = data.split("\n").map((val) => val.split(""));

  const result1 = part1(dataArray, 3, 1);
  console.log(result1);
  const result2 = part2(dataArray, type);
  console.log(result2);
});

const makePoints = (array, x, y) => {
  return array
    .map((val, idx) => {
      if (idx % y === 0) {
        return val[(x * (idx / y)) % array[0].length];
      }
    })
    .filter((x) => x !== null);
};

const part1 = (array, x, y) => {
  const points = makePoints(array, x, y);

  return points.filter((x) => x === "#").length;
};

const part2 = (array, slopes) => {
  return slopes
    .map(([right, down]) => {
      return part1(array, right, down);
    })
    .reduce((prev, current) => prev * current);
};
