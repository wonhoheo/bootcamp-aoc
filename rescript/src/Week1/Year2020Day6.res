// part1
// 그룹별 정답의 수의 합을 구해야함 reduce를 사용 // input 타입: array<int> result 타입: int
// 각각의 그룹의 응답을 카운트하는 배열을 생성 // input 타입: array<array<string>> result 타입: array<int>
// 그룹별로 분리된 배열내에서 각각의 그룹의 정답의 중복 제거(Belt.Set 사용) 및 1개의 배열로 변환 // input 타입: array<array<array<string>>> result 타입: array<array<string>>
// 그룹별로 분리된 배열내의 사람별로 정답을 분류 // input 타입:  array<array<string>> result 타입: array<array<array<string>>>
// 입력된 문자열을 그룹별로 분리하는 배열을 생성 // input 타입: string result 타입: array<array<string>>

let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day6.sample.txt")
let dataArray = Js.String2.split(input, "\n\n")

let groupPerson = array => array->Belt.Array.map(val => val->Js.String2.split("\n"))

let answerSum = array => {
  array->Belt.Array.reduce(0, (prev, current) => prev + current)
}

let groupAnswer = array => {
  array->Belt.Array.map(val => val->Belt.Array.map(v => v->Js.String2.split("")))
}

let set = array => {
  array->Belt.Array.map(val =>
    val->Belt.Array.concatMany->Belt.Set.String.fromArray->Belt.Set.String.toArray
  )
}
let answerSize = array => {
  array->Belt_Array.map(val => val->Belt.Array.size)
}
let part1 = dataArray->groupPerson->groupAnswer->set->answerSize->answerSum
// part1->Js.log

// ----------------------------------------------------------------------------

let multiLineToSet = str => {
  let x1 = str->Js.String2.split("\n")
  let x2 = x1->Belt.Array.map(s => s->Js.String2.split(""))->Belt.Array.concatMany
  x2->Belt.Set.String.fromArray->Belt.Set.String.size
}

let allToGroup = str => {
  str->Js.String2.split("\n\n")
}
let sum = xs => xs->Belt.Array.reduce(0, (prev, current) => prev + current)
let program = (input, f) => input->allToGroup->Belt.Array.map(group => group->f)->sum

let part1Answer = input => program(input, multiLineToSet)
input->part1Answer->Js.log

// part2
// 그룹별 정답의 수의 합을 구해야함 reduce를 사용 // input 타입: array<int> result 타입: int
// 각각의 그룹의 응답을 카운트하는 배열을 생성 // input 타입: array<array<string>> result 타입: array<int>
// 그룹별로 분리된 배열 내에서 정답 string 값을 배열내의 값이 모두 포함하는지 여부를 확인하여 포함되는 값을 반환하는 배열생성 // input 타입: array<array<string>> result 타입: array<array<string>>
// 그룹별로 분리된 배열내에서 각각의 그룹의 정답의 중복 제거(Belt.Set 사용) 및 1개의 배열로 변환 // input 타입: array<array<array<string>>> result 타입: array<array<string>>
// 그룹별로 분리된 배열내의 사람별로 정답을 분류 // input 타입:  array<array<string>> result 타입: array<array<array<string>>>
// 입력된 문자열을 그룹별로 분리하는 배열을 생성 // input 타입: string result 타입: array<array<string>>

// let alphabetArray = Js.String2.split("", "abcdefghijklmnopqrstuvwxyz")->Belt.Set.String.fromArray

let distinctAnswers = str => {
  let x1 = str->Js.String2.split("\n")
  let x2 = x1->Belt.Array.map(s => s->Js.String2.split(""))
  let x3 = x2->Belt.Array.map(val => val->Belt.Set.String.fromArray)
  // x3->Belt.Array.reduce(alphabetArray, (a, b) => Belt.Set.String.intersect(a, b))
  x3->Garter.Array.reduce1((a, b) => Belt.Set.String.intersect(a, b))
}

input
->allToGroup
->Belt.Array.map(group => group->distinctAnswers)
->Belt.Array.map(val => val->Belt.Set.String.size)
->sum
->Js.log
