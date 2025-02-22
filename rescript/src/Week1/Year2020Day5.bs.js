// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_format = require("rescript/lib/js/caml_format.js");
var Belt_SortArrayInt = require("rescript/lib/js/belt_SortArrayInt.js");
var Caml_external_polyfill = require("rescript/lib/js/caml_external_polyfill.js");

var input = Fs.readFileSync("input/Week1/Year2020Day5.sample.txt", "utf8");

var dataArray = Belt_Array.map(input.split("\n"), (function (val) {
        return val.split("");
      }));

function stringToBinary(str) {
  switch (str) {
    case "B" :
    case "R" :
        return 1;
    default:
      return 0;
  }
}

function arrayTypeChange(array) {
  return Belt_Array.map(array, (function (val) {
                return Belt_Array.map(val, stringToBinary);
              }));
}

function convertNumber(numString, toBase) {
  var val;
  var val$1;
  try {
    val = Caml_format.caml_int_of_string(numString);
    val$1 = toBase >= 2 && toBase < 36;
  }
  catch (exn){
    return "";
  }
  if (val$1) {
    return val.toString(toBase);
  } else {
    return "";
  }
}

function binaryToDeciaml(array) {
  return Belt_Array.map(Belt_Array.map(array, (function (val) {
                    return val.join("");
                  })), (function (v) {
                return Caml_external_polyfill.resolve("parseInt")(v, 2);
              }));
}

function findHighestSeat(array) {
  return Belt_Array.reduce(array, 1, (function (prev, current) {
                if (prev > current) {
                  return prev;
                } else {
                  return current;
                }
              }));
}

var seatIdArray = binaryToDeciaml(arrayTypeChange(dataArray));

console.log(findHighestSeat(seatIdArray));

function toSlideWindow(val) {
  var length = val.length - 1 | 0;
  var sidePair = Belt_Array.slice(val, 1, length);
  return Belt_Array.zip(val, sidePair);
}

function findMySeat(array) {
  return Belt_Option.mapWithDefault(Belt_Array.get(Belt_Array.keep(array, (function (param) {
                        return (param[1] - param[0] | 0) !== 1;
                      })), 0), 0, (function (param) {
                return param[0] + 1 | 0;
              }));
}

console.log(findMySeat(toSlideWindow(Belt_SortArrayInt.stableSort(seatIdArray))));

console.log(findMySeat(toSlideWindow(Belt_SortArrayInt.stableSort(seatIdArray))));

exports.input = input;
exports.dataArray = dataArray;
exports.stringToBinary = stringToBinary;
exports.arrayTypeChange = arrayTypeChange;
exports.convertNumber = convertNumber;
exports.binaryToDeciaml = binaryToDeciaml;
exports.findHighestSeat = findHighestSeat;
exports.seatIdArray = seatIdArray;
exports.toSlideWindow = toSlideWindow;
exports.findMySeat = findMySeat;
/* input Not a pure module */
