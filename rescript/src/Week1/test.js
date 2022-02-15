const fs = require("fs");
const util = require("util");
const _ = require("lodash");
const read = util.promisify(fs.readFile);

const loadGroup = async () => {
  const file = await read("input/Week1/Year2020Day6.sample.txt", "utf8");
  const groups = file.split("\n\n").map((group) => group.split("\n"));

  return groups;
};

const intersection = (group) => {
  return _.intersection(...group.map((person) => person.split(""))).length;
};

const part2 = async () => {
  const groups = await loadGroup();
  let count = 0;
  for (let i = 0; i < groups.length; i++) {
    count += intersection(groups[i]);
  }
  console.log("Total part 2", count);
};

part2();
