#
# Copyright (c) 2017 Adel Qalieh
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

import std/unittest
import ulid

suite "ulid":
  test "should return correct length":
    check(ulid().len == 26)

  test "should return expected encoded time component result":
    check("01ARYZ6S41" == ulid(1469918176385.int)[0..<10])

suite "encodeRandom":
  test "should return correct length":
    check(encodeRandom().len == 16)

  test "should return correct length when changed":
    check(encodeRandom(12).len == 12)

suite "encodeTime":
  test "should return expected encoded result":
    check("01ARYZ6S41" == encodeTime(1469918176385.int, 10))

  test "should change length properly":
    check("0001AS99AA60" == encodeTime(1470264322240.int, 12))

  test "should truncate time if not enough length":
    check("AS4Y1E11" == encodeTime(1470118279201.int, 8))
