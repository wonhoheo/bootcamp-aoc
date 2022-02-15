// // --- Day 4: Passport Processing ---
// // part1
// // 1. passport 타입을 생각해봅시다. *문제와 동일하게* record로 선언하세요.
type passport = {
  byr: string,
  iyr: string,
  eyr: string,
  hgt: string,
  hcl: string,
  ecl: string,
  pid: string,
  cid: option<string>,
}

let input = Node.Fs.readFileAsUtf8Sync("../../input/Week1/Year2020Day4.sample.txt")

// string 타입의 입력을 passport 타입으로 파싱하는 parsePassport 함수를 작성해보세요.
// string => passport

// byr:1930 pid:6999766453 ecl:#3e3e07
// hcl:#602927 iyr:2010 eyr:2039
// hgt:160cm
let parsePassport = input => {
  // 그룹별로 나누기
  let splitGroup = d => Js.String.split("\r\n\r\n", d)
  // 공백단위로 나눔
  let splitSpace = d => Js.String.splitByRe(%re("/\s/"), d)->Belt.Array.keepMap(v => v) // array<Js.String.t>
  // : 단위로 나눔
  let splitValue = d => Js.String.split(":", d)

  // 그룹별 데이터 가공 array<array<string>> => array<(string, string)>
  let arrToPair = d =>
    d
    ->Belt.Array.map(x => {
      switch (x->Belt.Array.get(0), x->Belt.Array.get(1)) {
      | (Some(k), Some(v)) => Some((k, v))
      | _ => None
      }
    })
    ->Belt.Array.keepMap(v => v)

  let arrToMap = d => d->Belt.Map.String.fromArray

  let passport = d => {
    let byr = d->Belt.Map.String.get("byr")
    let iyr = d->Belt.Map.String.get("iyr")
    let eyr = d->Belt.Map.String.get("eyr")
    let hgt = d->Belt.Map.String.get("hgt")
    let hcl = d->Belt.Map.String.get("hcl")
    let ecl = d->Belt.Map.String.get("ecl")
    let pid = d->Belt.Map.String.get("pid")
    let cid = d->Belt.Map.String.get("cid")

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

  input
  ->splitGroup //array<string>
  ->Belt.Array.map(v => v->splitSpace) // array<array<string>>
  ->Belt.Array.map(v => v->Belt.Array.map(x => x->splitValue)) // array<array<array<string>>>
  ->Belt.Array.map(v => v->arrToPair) // array<('a, 'a)>
  ->Belt.Array.map(v => v->arrToMap) // array<Belt.Map.String.t<Js.String.t>>
  ->Belt.Array.map(passport) // array<option<passport>>
  ->Belt.Array.keepMap(v => v)
}

// 3. 올바른 Passport를 세는 countPassport 함수를 만들어서 문제를 해결해봅시다.
let countPassport = d => d->Belt.Array.size

// part2
// let countPassport: array<passport> => int = _ => 0

type hgt = Cm(int) | In(int)
type ecl = Amb | Blu | Brn | Gry | Grn | Hzl | Oth

type passport2 = {
  byr: int,
  iyr: int,
  eyr: int,
  hgt: hgt,
  hcl: string,
  ecl: ecl,
  pid: string,
  cid: option<string>,
}

let parsePassport2 = input => {
  let split: string => array<array<array<string>>> = d => {
    // array<array<array<string>>>
    // 그룹별로 나누기
    let splitGroup = d => Js.String.split("\r\n\r\n", d)
    // 공백단위로 나눔
    let splitSpace = data => Js.String.splitByRe(%re("/\s/"), data)->Belt.Array.keepMap(v => v)
    // : 단위로 나눔
    let splitValue = data => Js.String.split(":", data)

    d->splitGroup->Belt.Array.map(splitSpace)->Belt.Array.map(x => x->Belt.Array.map(splitValue))
  }

  let arrToPair = d =>
    // option<(string, string)>  array<array<option<(string, string)>>>
    switch (d->Belt.Array.get(0), d->Belt.Array.get(1)) {
    | (Some(k), Some(v)) => Some((k, v))
    | _ => None
    }

  // map :: (a -> b) -> Option<a> -> Option<b>
  // list<promise<'a>> => promise<list<'a>>
  // Promise.all :: array<promise<'a>> => promise<array<'a>>
  // 옵션인 배열중에서, 원소가 하나라도 none이면 None
  // 모두 Some일때만 Some<array<'a>>
  let sequence: array<option<('a, 'a)>> => option<array<('a, 'a)>> = input => {
    // array<option<array<(string, string)>>>
    switch input->Belt.Array.some(Belt.Option.isSome) {
    | true => Some(input->Belt.Array.keepMap(x => x))
    | false => None
    }
  }

  let pairArrToMap = d =>
    // array<option<Belt.Map.String.t<string>>>
    d->Belt.Map.String.fromArray

  let range = (num, min, max) => {
    switch (num >= min, num <= max) {
    | (true, true) => Some(num)
    | _ => None
    }
  }

  let parseHeight = str => {
    // string -> option<hgt>
    let stringToHeight = str => {
      let unit = Js.String.sliceToEnd(~from=-2, str)
      let value = Js.String.slice(~from=0, ~to_=-2, str)->Belt.Int.fromString
      switch (unit, value) {
      | ("cm", Some(num)) => Some(Cm(num))
      | ("in", Some(num)) => Some(In(num))
      | _ => None
      }
    }

    let parseValueByUnit = hgt => {
      switch hgt {
      | Cm(value) => value->range(150, 193)->Belt.Option.map(x => Cm(x))
      | In(value) => value->range(59, 76)->Belt.Option.map(x => In(x))
      }
    }
    str->stringToHeight->Belt.Option.flatMap(parseValueByUnit)
  }

  let parseHairColor = str => {
    let rule = %re("/^#[a-z0-9+]{6}$/")
    switch Js.Re.test_(rule, str) {
    | true => Some(str)
    | false => None
    }
  }

  let parseEyeColor = str => {
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

  let parsePassportId = str => {
    let rule = %re("/^0*[0-9+]{9}$/")
    switch Js.Re.test_(rule, str) {
    | true => Some(str)
    | false => None
    }
  }

  let mapToPassport2 = d => {
    let byr =
      d
      ->Belt.Map.String.get("byr")
      ->Belt.Option.flatMap(Belt.Int.fromString)
      ->Belt.Option.flatMap(x => x->range(1920, 2002))
    let iyr =
      d
      ->Belt.Map.String.get("iyr")
      ->Belt.Option.flatMap(Belt.Int.fromString)
      ->Belt.Option.flatMap(x => x->range(2010, 2020))
    let eyr =
      d
      ->Belt.Map.String.get("eyr")
      ->Belt.Option.flatMap(Belt.Int.fromString)
      ->Belt.Option.flatMap(x => x->range(2020, 2030))
    let hgt = d->Belt.Map.String.get("hgt")->Belt.Option.flatMap(parseHeight)
    let hcl = d->Belt.Map.String.get("hcl")->Belt.Option.flatMap(parseHairColor)
    let ecl = d->Belt.Map.String.get("ecl")->Belt.Option.flatMap(parseEyeColor)
    let pid = d->Belt.Map.String.get("pid")->Belt.Option.flatMap(parsePassportId)
    let cid = d->Belt.Map.String.get("cid")

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

  input
  ->split
  ->Belt.Array.map(x => x->Belt.Array.map(arrToPair)) // array<array<option<(string, string)>>>
  ->Belt.Array.map(xs => xs->sequence) // array<option<array<(string, string)>>>  // array<(string, string)>
  ->Belt.Array.map(x => x->Belt.Option.map(pairArrToMap)) // array<option<Belt.Map.String.t<string>>>
  ->Belt.Array.map(x => x->Belt.Option.flatMap(mapToPassport2))
}

// 출력
input->parsePassport->countPassport->Js.log
input->parsePassport2->countPassport->Js.log
