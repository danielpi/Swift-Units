import Cocoa
//import Units

let bluetoothRange = Length(m:30)
let lanes = 2
let laneWidth = Length(m: 3.5)

let distanceToAdjacentLane = Length(m:0.5) + Length(m: (Double(lanes) * laneWidth.m) / 2.0)
let distanceToOppositeLane = Length(m:0.5) + Length(m: Double(lanes) * laneWidth.m) + Length(m:0.5) + Length(m: (Double(lanes) * laneWidth.m) / 2.0)

let distanceInRangeForAdjacent = Length(m: 2.0 * pow(pow(bluetoothRange.m,2) - pow(distanceToAdjacentLane.m,2), 0.5))
let distanceInRangeForOpposite = Length(m: 2.0 * pow(pow(bluetoothRange.m,2) - pow(distanceToOppositeLane.m,2), 0.5))


indirect enum Expr {
    case Sum(Expr, Expr)
    case Product(Expr, Expr)
    case Constant(Int)
    case Variable(String)
}

let acceleration = Expr.Constant(5)
let mass = Expr.Constant(2)

let sampleTime = Time(sec: 0.02)
sampleTime.frequency
