external parseInt: (string, int) => int = "parseInt"

let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day5.sample.txt")
let dataArray = Js.String2.split(input, "\n")->Belt.Array.map(val => Js.String2.split(val, ""))
// part1
// 가장 높은 seat Id 값(int)
// 그러면 가장 높은 값은 어떻게 구하는가? (max값을 구하는 함수)
// 가장 높은 값을 구하기 위해서 어떠한 데이터가 필요한지? (데이터 가공 함수)
// 그 데이터는 어떤형태를 띄는지? (타입이 string 이므로 int로 변경)
// 들어오는 데이터는 string 형태

// 문자열을 이진수의 형태로 변환하는 함수
let stringToBinary = str => {
  switch str {
  | "B" => 1
  | "R" => 1
  | _ => 0
  }
}

// 배열화된 데이터 Array<Array<string>> -> Array<Array<int>> 로 변환
let arrayTypeChange = array => {
  array->Belt.Array.map(val => val->Belt.Array.map(stringToBinary))
}

// string 타입의 숫자데이터를 해당 진수의 int로 변환하기위 한 함수
let convertNumber = (numString, toBase) => {
  switch (int_of_string(numString), toBase >= 2 && toBase < 36) {
  | exception _ => ""
  | (_, false) => ""
  | (n, true) => Js.Int.toStringWithRadix(n, ~radix=toBase)
  }
}
// Array<Array<int>> -> Array<int>
let binaryToDeciaml = array => {
  array->Belt.Array.map(val => val->Js.Array2.joinWith(""))->Belt.Array.map(v => v->parseInt(2))
}

let findHighestSeat = array => {
  array->Belt.Array.reduce(1, (prev, current) => {
    prev > current ? prev : current
  })
}

let seatIdArray = dataArray->arrayTypeChange->binaryToDeciaml
seatIdArray->findHighestSeat->Js.log

// part2
// part1 과 동일 하지만 최대값을 구하지 않고 오름차순으로 정렬 후 slideWindow 알고리즘을 통해 빈값 비교
//
let toSlideWindow = val => {
  let length = val->Belt.Array.length - 1
  let sidePair = val->Belt.Array.slice(~offset=1, ~len=length)

  val->Belt.Array.zip(sidePair)
}

let findMySeat = array => {
  array
  ->Belt.Array.keep(((val1, val2)) => val2 - val1 !== 1)
  ->Belt.Array.get(0) // option<>
  ->Belt.Option.mapWithDefault(0, ((val, _)) => val + 1)
}

seatIdArray->Belt.SortArray.Int.stableSort->toSlideWindow->findMySeat->Js.log
Js.log(findMySeat(toSlideWindow(Belt.SortArray.Int.stableSort(seatIdArray))))
