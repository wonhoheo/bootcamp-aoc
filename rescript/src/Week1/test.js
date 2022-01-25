const fs = require("fs");

const text = fs.readFileSync("input/Week1/Year2020Day3.sample.txt", 'utf-8');
const map = text.toString().split("\n");
console.log(map);
// const map = text.split("\n").map(line => console.log(line + "&&&&&&&&&&&&&&&&&"))

// console.log(map)

// map.forEach(el => {
//   el.pop()
// }); // '\r' 제거

// console.log(map)

let x = 0;
let y = 0;
let countTrees = 0;
let bottom = map.length;

while (true) {
  x += 3;
  y += 1;

  if (y >= bottom) {
    break;
  }
  // console.log(`x: ${x}   y:${y}   ${map[y][x % map[y].length]}`)
  if (map[y][x % map[y].length] === "#") {
    countTrees++;
    // console.log(countTrees)
  }
}
console.log(countTrees);