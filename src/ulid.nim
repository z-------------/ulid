import std/[
  strutils,
  random,
  times,
]

const
  Encoding = "0123456789ABCDEFGHJKMNPQRSTVWXYZ" # Crockford's Base32
  EncodingLen = Encoding.len
  TimeMax = 1 shl 48 - 1
  TimeLen = 10
  RandomLen = 16

template `=<`[T](a, b: T): T =
  a = b
  a

type
  UlidKind* = enum
    ukPolytonic
    ukMonotonic
  Ulid* = object
    case kind: UlidKind
    of ukPolytonic:
      discard
    of ukMonotonic:
      lastTime: int
      lastRandom: string

func replaceCharAt*(str: string; index: int; c: char): string =
  if index > str.len - 1:
    str
  else:
    str[0..<index] & c & str[index + 1 .. str.high]

func incrementBase32*(str: string): string =
  var
    str = str
    idx = str.len
    c: char
    cIdx: int
  let maxCharIdx = EncodingLen - 1
  while result == default(string) and (dec idx; idx) >= 0:
    c = str[idx]
    cIdx = Encoding.find(c)
    if cIdx == -1:
      raise newException(ValueError, "Incorrectly encoded string")
    if cIdx == maxCharIdx:
      str = str.replaceCharAt(idx, Encoding[0])
      continue
  if result == default(string):
    raise newException(ValueError, "Cannot increment this string")

func encodeTime*(now: int; len = TimeLen): string =
  var now = now
  if now > TimeMax:
    raise newException(ValueError, "Cannot encode time greater than " & $TimeMax)
  if now < 0:
    raise newException(ValueError, "Time must be positive")
  var m: int
  for _ in countdown(len, 1):
    m = now mod EncodingLen
    result = Encoding[m] & result
    now = (now - m) div EncodingLen

proc encodeRandom*(len = RandomLen): string =
  for _ in countdown(len, 1):
    result = Encoding[rand(EncodingLen - 1)] & result

func decodeTime*(id: string): int =
  raise newException(CatchableError, "Not implemented!")

func initUlid*(kind = ukPolytonic): Ulid =
  Ulid(kind: kind)

proc ulid*(u: var Ulid; seedTime = int(times.epochTime() * 1000)): string =
  case u.kind
  of ukPolytonic:
    encodeTime(seedTime) & encodeRandom()
  of ukMonotonic:
    if seedTime <= u.lastTime:
      let incrementedRandom = (u.lastRandom =< u.lastRandom.incrementBase32())
      encodeTime(u.lastTime) & incrementedRandom
    else:
      u.lastTime = seedTime
      let newRandom = (u.lastRandom =< encodeRandom())
      encodeTime(seedTime) & newRandom

proc ulid*(seedTime = int(times.epochTime() * 1000)): string =
  var ulid = initUlid(ukPolytonic)
  ulid.ulid(seedTime)
