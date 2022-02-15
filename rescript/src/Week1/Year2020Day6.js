const fs = require("fs");
const part1 = () => {
  fs.readFile("input/Week1/Year2020Day6.sample.txt", "utf8", (err, data) => {
    let dataArray = data.toString().split("\n");
    let groupAnswers = new Set();
    let result = 0;

    dataArray.forEach((val, idx) => {
      if (val !== "") {
        val.split("").forEach((answer) => groupAnswers.add(answer));
      }

      if (idx === dataArray.length - 1 || val === "") {
        const totalGroupAnswers = groupAnswers.size;
        groupAnswers.clear();
        result += totalGroupAnswers;
      }
    });
    console.log(result);
  });
};

const part2 = () => {
  fs.readFile("input/Week1/Year2020Day6.sample.txt", "utf8", (err, data) => {
    let dataArray = data.toString().split("\n");
    let result = 0;

    let sortArray = [];
    let tempArray = [];

    dataArray.forEach((val, idx) => {
      if (val !== "") {
        tempArray.push(val);
      }

      if (idx === dataArray.length - 1 || val === "") {
        sortArray.push(tempArray);
        tempArray = [];
      }
    });

    sortArray.forEach((answers) => {
      const combinedAnswers = answers.join("");
      const distinctAnswers = [...new Set(combinedAnswers.split(""))];

      distinctAnswers.forEach((val) => {
        const answer = val;
        if (answers.every((x) => x.includes(answer))) result += 1;
      });
    });
    console.log(result);
  });
};

part2();
