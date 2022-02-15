let text = Node.Fs.readFileAsUtf8Sync("input/Week2/Year2020Day4.sample.txt")
// --- Day 4: Passport Processing ---

/*
cid:257
ecl:gry hgt:186cm iyr:2012
byr:1941
eyr:2029
pid:108935675
hcl:#cfa07d
*/

type ecl = Amb | Blu | Brn | Gry | Grn | Hzl | Oth

type hgt = Cm(int) | In(int)

// "amb" "blu"
let stringToEcl = str => {
  switch str {
  | "amb" => Some(Amb)
  | "blu" => Some(Blu)
  | _ => None
  }
}

type passport = {
  byr: int, //(출생 년도) // 1920~2002
  iyr: int, //(발행 연도) // 2010~2020
  eyr: int, //(만료 연도) // 2020~2030
  hgt: string, //(키) // 100~200cm, 50~70in
  // hgt: hgt,
  hcl: string, //(머리 색깔)
  ecl: string, //(눈 색깔) // amb|blu|brn|gry|grn|hzl|oth
  // ecl: ecl,
  pid: string, //(여권 아이디)
  cid: option<string>, //(국가 ID)
}

let countPassport: array<option<passport>> => _ = arr => {
  arr
  ->Belt.Array.map(x => x->Belt.Option.isSome)
  ->Belt.Array.reduce(0, (total, curr) => total + (curr ? 1 : 0))
}

let checkPassport = passport => {
  switch passport {
  | Some(passport) => {
      let fieldDefinitions = {
        "hgt": %re("/^(?:(?:1[5-9][0-9]|19[0-3])cm|(?:59|6[0-9]|7[0-6])in)$/"),
        "hcl": %re("/^#[0-9a-f]{6}$/"),
        "ecl": %re("/^(?:amb|blu|brn|gry|grn|hzl|oth)$/"),
        "pid": %re("/^\d{9}$/"),
      }

      let byr = Belt.Range.some(1920, 2002, i => i === passport.byr)
      let iyr = Belt.Range.some(2010, 2020, i => i === passport.iyr)
      let eyr = Belt.Range.some(2020, 2030, i => i === passport.eyr)
      let hgt = Js.Re.test_(fieldDefinitions["hgt"], passport.hgt)
      let hcl = Js.Re.test_(fieldDefinitions["hcl"], passport.hcl)
      let ecl = Js.Re.test_(fieldDefinitions["ecl"], passport.ecl)
      let pid = Js.Re.test_(fieldDefinitions["pid"], passport.pid)

      switch Belt.Array.every([byr, iyr, eyr, hgt, hcl, ecl, pid], x => x == true) {
      | true => Some(passport)
      | false => None
      }
    }
  | None => None
  }
}

let makePassport = tuple => {
  let byr = tuple->Belt.Map.String.get("byr")->Belt.Option.flatMap(Belt.Int.fromString)
  let iyr = tuple->Belt.Map.String.get("iyr")->Belt.Option.flatMap(Belt.Int.fromString)
  let eyr = tuple->Belt.Map.String.get("eyr")->Belt.Option.flatMap(Belt.Int.fromString)
  let hgt = tuple->Belt.Map.String.get("hgt")
  let hcl = tuple->Belt.Map.String.get("hcl")
  let ecl = tuple->Belt.Map.String.get("ecl")
  let pid = tuple->Belt.Map.String.get("pid")
  let cid = tuple->Belt.Map.String.get("cid")

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
// :: [("ecl","gry"),("pid",...)] -> [{ecl: "gry", pid: ...}]

let convertTuple = arr => {
  arr
  ->Belt.Array.map(x =>
    switch (x->Belt.Array.get(0), x->Belt.Array.get(1)) {
    | (Some(a), Some(b)) => Some(a, b)
    | _ => None
    }
  )
  ->Belt.Array.keepMap(x => x)
  ->Belt.Map.String.fromArray
}
// :: [["ecl","gry"],["pid",...],...] -> [("ecl","gry"),("pid",...),...]

let parsePassport = arr => {
  arr->Belt.Array.map(array => array->convertTuple->makePassport)
}

let convertArray = input => {
  input
  ->Js.String2.split("\n\n")
  ->Belt.Array.map(str =>
    str
    ->Js.String2.replaceByRe(%re("/\\n/g"), " ")
    ->Js.String2.split(" ")
    ->Belt.Array.map(str => str->Js.String2.split(":"))
  )
}
// :: "ecl:gry pid:860033327 ..." ->  [["ecl:gry","pid:860033327","eyr:2020", ...], ...] -> [[["ecl","gry"],["pid",...],...],...]
// :: string -> array<array<string>> -> array<array<array<string>>>

let part1 = input => {
  input->convertArray->parsePassport->countPassport
}

let part2 = input => {
  input->convertArray->parsePassport->Belt.Array.map(checkPassport)->countPassport
}

part1(text)->Js.log
part2(text)->Js.log

/*
참고 링크
- https://rescript-lang.org/docs/manual/latest/record
- https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
*/
