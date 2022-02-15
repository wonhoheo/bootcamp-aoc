// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Belt_Int = require("rescript/lib/js/belt_Int.js");
var Caml_obj = require("rescript/lib/js/caml_obj.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Belt_MapString = require("rescript/lib/js/belt_MapString.js");

var input = Fs.readFileSync("input/Week2/Year2020Day4.sample.txt", "utf8");

function inputToArray(str) {
  var reg = /\n/g;
  return Belt_Array.map(str.split("\n\n"), (function (val) {
                return Belt_Array.map(val.replace(reg, " ").split(" "), (function (v) {
                              return v.split(":");
                            }));
              }));
}

function parsingRange(num, min, max) {
  var match = Caml_obj.caml_greaterequal(num, min);
  var match$1 = Caml_obj.caml_lessequal(num, max);
  if (match && match$1) {
    return Caml_option.some(num);
  }
  
}

function parsingEcl(str) {
  switch (str) {
    case "amb" :
        return /* Amb */0;
    case "blu" :
        return /* Blu */1;
    case "brn" :
        return /* Brn */2;
    case "grn" :
        return /* Grn */4;
    case "gry" :
        return /* Gry */3;
    case "hzl" :
        return /* Hzl */5;
    case "oth" :
        return /* Oth */6;
    default:
      return ;
  }
}

function parsingHgt(str) {
  var stringToHgt = function (str) {
    var unit = str.slice(-2);
    var value = Belt_Int.fromString(str.slice(0, -2));
    switch (unit) {
      case "cm" :
          if (value !== undefined) {
            return {
                    TAG: /* Cm */0,
                    _0: value
                  };
          } else {
            return ;
          }
      case "in" :
          if (value !== undefined) {
            return {
                    TAG: /* In */1,
                    _0: value
                  };
          } else {
            return ;
          }
      default:
        return ;
    }
  };
  var parseValue = function (val) {
    if (val.TAG === /* Cm */0) {
      return Belt_Option.map(parsingRange(val._0, 150, 193), (function (x) {
                    return {
                            TAG: /* Cm */0,
                            _0: x
                          };
                  }));
    } else {
      return Belt_Option.map(parsingRange(val._0, 59, 76), (function (x) {
                    return {
                            TAG: /* In */1,
                            _0: x
                          };
                  }));
    }
  };
  return Belt_Option.flatMap(stringToHgt(str), parseValue);
}

function parsingHcl(str) {
  var rule = /^#[a-z0-9+]{6}$/;
  if (rule.test(str)) {
    return str;
  }
  
}

function parsingPid(str) {
  var rule = /^0*[0-9+]{9}$/;
  if (rule.test(str)) {
    return str;
  }
  
}

function setPassport(array) {
  return Belt_Array.reduce(array, undefined, (function (acc, v) {
                if (v.length !== 2) {
                  return acc;
                }
                var key = v[0];
                var value = v[1];
                return Belt_MapString.set(acc, key, value);
              }));
}

var requiredFields = [
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid"
];

function countPassport(passport) {
  return Belt_Array.every(requiredFields, (function (v) {
                return Belt_MapString.has(passport, v);
              }));
}

var f = Belt_Array.keep(Belt_Array.map(inputToArray(input), setPassport), countPassport);

console.log(f.length);

function parsePassport(map) {
  var byr = Belt_Option.flatMap(Belt_Option.flatMap(Belt_MapString.get(map, "byr"), Belt_Int.fromString), (function (x) {
          return parsingRange(x, 1920, 2002);
        }));
  var iyr = Belt_Option.flatMap(Belt_Option.flatMap(Belt_MapString.get(map, "iyr"), Belt_Int.fromString), (function (x) {
          return parsingRange(x, 2010, 2020);
        }));
  var eyr = Belt_Option.flatMap(Belt_Option.flatMap(Belt_MapString.get(map, "eyr"), Belt_Int.fromString), (function (x) {
          return parsingRange(x, 2020, 2030);
        }));
  var hgt = Belt_Option.flatMap(Belt_MapString.get(map, "hgt"), parsingHgt);
  var hcl = Belt_Option.flatMap(Belt_MapString.get(map, "hcl"), parsingHcl);
  var ecl = Belt_Option.flatMap(Belt_MapString.get(map, "ecl"), parsingEcl);
  var pid = Belt_Option.flatMap(Belt_MapString.get(map, "pid"), parsingPid);
  var cid = Belt_MapString.get(map, "cid");
  if (byr !== undefined && iyr !== undefined && eyr !== undefined && hgt !== undefined && hcl !== undefined && ecl !== undefined && pid !== undefined) {
    return {
            byr: byr,
            iyr: iyr,
            eyr: eyr,
            hgt: hgt,
            hcl: hcl,
            ecl: ecl,
            pid: pid,
            cid: cid
          };
  }
  
}

console.log(Belt_Array.keepMap(f, parsePassport).length);

exports.input = input;
exports.inputToArray = inputToArray;
exports.parsingRange = parsingRange;
exports.parsingEcl = parsingEcl;
exports.parsingHgt = parsingHgt;
exports.parsingHcl = parsingHcl;
exports.parsingPid = parsingPid;
exports.setPassport = setPassport;
exports.requiredFields = requiredFields;
exports.countPassport = countPassport;
exports.f = f;
exports.parsePassport = parsePassport;
/* input Not a pure module */
