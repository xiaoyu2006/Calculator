//
//  Fraction.swift
//  Calculator
//
//  Created by Nemo on 2019/10/13.
//  Copyright © 2019 NJU. All rights reserved.
//

import Foundation


let chr0: UInt8 = Character("0").asciiValue!

// Fraction: a / b
class Fraction {
    var a: UInt64 = 0
    var b: UInt64 = 1
    var isNeg: Bool = false
    
    func gcd(_ a: UInt64, _ b: UInt64) -> UInt64 {
        if a == 0 {
            return b
        } else if b == 0 {
            return a
        } else if a == b {
            return a
        } else if a > b {
            return gcd(a % b, b)
        } else {
            return gcd(a, b % a)
        }
    }
    
    func min() -> Void {
        let div = gcd(a, b)
        if div == 0 {
            return
        }
        a /= div
        b /= div
        // Positive while this fraction is 0
        if a == 0 {
            isNeg = false
        }
    }
    
    init(fromString str: String = "0.0") {
        if str == "INF" || str == "-INF" {
            b = 0
            return
        }
        var afterDot: Bool = false
        var num: UInt64 = 0
        var numAfterDot: UInt64 = 1
        var onlyZerosAfterDot: Bool = true
        isNeg = false
        for chr in str {
            if chr == "-" {
                isNeg = true
            } else if chr == "." {
                afterDot = true
            } else if afterDot {
                if chr == "0" {
                    onlyZerosAfterDot = onlyZerosAfterDot && false
                } else {
                    onlyZerosAfterDot = false
                }
                numAfterDot *= 10
                num = num * 10 + UInt64(chr.asciiValue! - chr0)
            } else {
                num = num * 10 + UInt64(chr.asciiValue! - chr0)
            }
        }
        a = num
        if onlyZerosAfterDot {
            b = 1
        } else {
            b = numAfterDot
        }
        min()
    }
    
    func toString() -> String {
        var result: String = ""
        if isNeg {
            result = "-"
        }
        if b == 0 {
            var neg = ""
            if isNeg {
                neg = "-"
            }
            return neg + "INF"
        }
        // If a MOD b = 0
        if Double(a / b) == Double(a) / Double(b) {
            result += String(a / b)
            return result
        }
        result += String(Double(a) / Double(b))
        return result
    }
    
    func toFrac() -> String {
        var result: String = ""
        if isNeg {
            result = "-"
        }
        result += String(a) + "/" + String(b)
        return result
    }
}


// Operators
func <(left: Fraction, right: Fraction) -> Bool {
    if left.isNeg == right.isNeg {
        if left.isNeg {
            return left.a * right.b > left.b * right.a
        } else {
            return left.a * right.b < left.b * right.a
        }
    } else {
        if left.isNeg {
            return false
        } else {
            return true
        }
    }
}

func >(left: Fraction, right: Fraction) -> Bool {
    if left.isNeg == right.isNeg {
        if left.isNeg {
            return left.a * right.b < left.b * right.a
        } else {
            return left.a * right.b > left.b * right.a
        }
    } else {
        if left.isNeg {
            return true
        } else {
            return false
        }
    }
}

func ==(left: Fraction, right: Fraction) -> Bool {
    if left.isNeg != right.isNeg {
        return false
    } else {
        return left.a * right.b == left.b * right.a
    }
}

func +(left: Fraction, right: Fraction) -> Fraction {
    let result = Fraction()
    let isNegl = left.isNeg
    let isNegr = right.isNeg
    // Absolute value
    left.isNeg = false
    right.isNeg = false
    if left > right {
        result.isNeg = isNegl
    } else if left < right {
        result.isNeg = isNegr
    } else {
        result.isNeg = false
        return result
    }
    if isNegl == isNegr {
        result.a = left.a * right.b + left.b * right.a
    } else {
        if left > right {
            result.a = left.a * right.b - left.b * right.a
        } else {
            result.a = left.b * right.a - left.a * right.b
        }
    }
    result.b = left.b * right.b
    result.min()
    return result
}

func -(left: Fraction, right: Fraction) -> Fraction {
    // right <- -right
    right.isNeg = !right.isNeg
    return left + right
}

func *(left: Fraction, right: Fraction) -> Fraction {
    let result = Fraction()
    result.a = left.a * right.a
    result.b = left.b * right.b
    result.min()
    result.isNeg = !(left.isNeg == right.isNeg)
    return result
}

func /(left: Fraction, right: Fraction) -> Fraction {
    // right <- 1/right
    let b = right.b
    right.b = right.a
    right.a = b
    return left * right
}
