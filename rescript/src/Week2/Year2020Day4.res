// --- Day 4: Passport Processing ---

let input = Node.Fs.readFileAsUtf8Sync("input/Week2/Year2020Day4.sample.txt")
let inputToArray = str => {
  let reg = %re("/\\n/g")
  str
  ->Js.String2.split("\n\n")
  ->Belt.Array.map(val =>
    val
    ->Js.String2.replaceByRe(reg, " ")
    ->Js.String2.split(" ")
    ->Belt.Array.map(v => v->Js.String2.split(":"))
  )
}

// [["hcl", "#cfa07d"], ["eyr", "2025"], ...]

type ecl = Amb | Blu | Brn | Gry | Grn | Hzl | Oth

type hgt = Cm(int) | In(int)

let parsingRange = (num, min, max) => {
  switch (num >= min, num <= max) {
  | (true, true) => Some(num)
  | _ => None
  }
}

let parsingEcl = str => {
  switch str {
  | "amb" => Some(Amb)
  | "blu" => Some(Blu)
  | "brn" => Some(Brn)
  | "gry" => Some(Gry)
  | "grn" => Some(Grn)
  | "hzl" => Some(Hzl)
  | "oth" => Some(Oth)
  | _ => None
  }
}

let parsingHgt = str => {
  let stringToHgt = str => {
    let unit = str->Js.String2.sliceToEnd(~from=-2)
    let value = str->Js.String2.slice(~from=0, ~to_=-2)->Belt.Int.fromString
    switch (unit, value) {
    | ("cm", Some(num)) => Some(Cm(num))
    | ("in", Some(num)) => Some(In(num))
    | _ => None
    }
  }

  let parseValue = val => {
    switch val {
    | Cm(value) => value->parsingRange(150, 193)->Belt.Option.map(x => Cm(x))
    | In(value) => value->parsingRange(59, 76)->Belt.Option.map(x => In(x))
    }
  }
  str->stringToHgt->Belt.Option.flatMap(parseValue)
}

let parsingHcl = str => {
  let rule = %re("/^#[a-z0-9+]{6}$/")
  switch Js.Re.test_(rule, str) {
  | true => Some(str)
  | false => None
  }
}
let parsingPid = str => {
  let rule = %re("/^0*[0-9+]{9}$/")
  switch Js.Re.test_(rule, str) {
  | true => Some(str)
  | false => None
  }
}

type passport = {
  byr: int,
  iyr: int,
  eyr: int,
  hgt: hgt,
  hcl: string,
  ecl: ecl,
  pid: string,
  cid: option<string>,
}

let setPassport = array => {
  array->Belt.Array.reduce(Belt.Map.String.empty, (acc, v) => {
    switch v {
    | [key, value] => acc->Belt.Map.String.set(key, value)
    | _ => acc
    }
  })
}

let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
let countPassport = passport => {
  requiredFields->Belt.Array.every(v => passport->Belt.Map.String.has(v))
}

let f = {
  input->inputToArray->Belt.Array.map(setPassport)->Belt.Array.keep(countPassport)
}
// part1
f->Belt.Array.length->Js.log

//---------------------------------

// let validatePassport = passport => {
//   passport.byr >= 1920 &&
//   passport.byr <= 2002 &&
//   passport.iyr >= 2010 &&
//   passport.iyr <= 2020 &&
//   passport.eyr >= 2020 &&
//   passport.eyr <= 2030 &&
//   switch Js.Re.exec_(%re("/(\d+)(cm|in)/g"), passport.hgt) {
//   | Some(result) => {
//       let height = Js.Re.matches(result)[1]->Belt.Int.fromString->Belt.Option.getWithDefault(0)
//       let unit = Js.Re.matches(result)[2]
//       if unit === "cm" {
//         height >= 150 && height <= 193
//       } else if unit === "in" {
//         height >= 59 && height <= 76
//       } else {
//         false
//       }
//     }
//   | _ => false
//   } &&
//   %re("/^#[\da-f]{6}$/")->Js.Re.test_(passport.hcl) &&
//   %re("/^amb|blu|brn|gry|grn|hzl|oth$/")->Js.Re.test_(passport.ecl) &&
//   %re("/^\d{9}$/")->Js.Re.test_(passport.pid)
// }

let parsePassport = map => {
  let byr =
    map
    ->Belt.Map.String.get("byr")
    ->Belt.Option.flatMap(Belt.Int.fromString)
    ->Belt.Option.flatMap(x => x->parsingRange(1920, 2002))
  let iyr =
    map
    ->Belt.Map.String.get("iyr")
    ->Belt.Option.flatMap(Belt.Int.fromString)
    ->Belt.Option.flatMap(x => x->parsingRange(2010, 2020))
  let eyr =
    map
    ->Belt.Map.String.get("eyr")
    ->Belt.Option.flatMap(Belt.Int.fromString)
    ->Belt.Option.flatMap(x => x->parsingRange(2020, 2030))
  let hgt = map->Belt.Map.String.get("hgt")->Belt.Option.flatMap(parsingHgt)
  let hcl = map->Belt.Map.String.get("hcl")->Belt.Option.flatMap(parsingHcl)
  let ecl = map->Belt.Map.String.get("ecl")->Belt.Option.flatMap(parsingEcl)
  let pid = map->Belt.Map.String.get("pid")->Belt.Option.flatMap(parsingPid)
  let cid = map->Belt.Map.String.get("cid")

  switch (byr, iyr, eyr, hgt, hcl, ecl, pid, cid) {
  | (Some(byr), Some(iyr), Some(eyr), Some(hgt), Some(hcl), Some(ecl), Some(pid), _) =>
    Some({
      byr: byr,
      iyr: iyr,
      eyr: eyr,
      hgt: hgt,
      hcl: hcl,
      ecl: ecl,
      pid: pid,
      cid: cid,
    })
  | _ => None
  }
}

// part2
f->Belt.Array.keepMap(parsePassport)->Belt.Array.length->Js.log
