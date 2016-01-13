import Cocoa
//import Units

// What power are you drawing from a battery that has a certain voltage and current

let voltage = Voltage(V: 96)
let current = Current(A: 200)

let power = voltage * current
power.kW


// How much torque could you generate from that power from a motor spinning at 1000rpm

let torque = power / AngularVelocity(rpm: 1500)


// What force would that apply at the end of a 5cm shaft

let force = torque / Length(cm: 5)

let force2 = Mass(kg: 13) * Acceleration(mps2: 0.5)
let force3 = Force(mass: 13.0, acceleration: 0.5)

// How fast would that force accelerate a 100 gram load

let acceleration = force / Mass(g: 100)

let v = Volume(cm3: 12000000000)
v.cm3
v.m3

/*
struct Latitude: Unit {
    var value: Double
    var baseSymbol: String = "φ"
    
}

//let a = Latitude(value: 13.0)
//let b = Latitude(value: 15.0)



struct Longitude: Unit {
    var value: Double
    var baseSymbol: String = "λ"
    
}
*/
/*
struct Coordinate {
    let latitude: Latitude
    let longitude: Longitude
    
    func distanceFrom(coordinate: Coordinate) -> Length {
        let(dLat, dLon) = (latitude - coordinate.latitude, Longitude - coordinate.longitude)
        return Length(km: 1)
    }
}
*/


postfix operator ° {}
postfix func °(degrees: Double) -> Double {return degrees * M_PI / 180.0}

struct Coordinate2 {
    let latitude: Double, longitude: Double
    enum EarthUnits: Double {case ImperialRadius = 3961.0,  MetricRadius = 6373.0}
    func distanceFrom(coordinate: Coordinate2, radius: EarthUnits = .MetricRadius) -> Double {
        let (dLat, dLon) = (self.latitude - coordinate.latitude, longitude - coordinate.longitude)
        let (sqSinLat, sqSinLon) = (pow(sin(dLat° / 2.0), 2.0), pow(sin(dLon° / 2.0), 2.0))
        let a = sqSinLat + sqSinLon * cos(latitude°) * cos(coordinate.latitude°)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        return c * radius.rawValue
    }
}

38.898556°
Latitude(degrees: 38.898556).radians

let whitehouse2 = Coordinate2(latitude: 38.898556, longitude: -77.037852)
let fstreet2 = Coordinate2(latitude: 38.897147, longitude: -77.043934)
whitehouse2.distanceFrom(fstreet2)


let whitehouse = Coordinate(latitude: Latitude(degrees: 38.898556), longitude: Longitude(degrees: -77.037852))
let fstreet = Coordinate(latitude: Latitude(degrees: 38.897147), longitude: Longitude(degrees: -77.043934))
whitehouse.distanceFrom(fstreet)

let testPoint = Coordinate(latitude: Latitude(degrees: 89), longitude: Longitude(degrees: 0))
let testPoint2 = Coordinate(latitude: Latitude(degrees: 89), longitude: Longitude(degrees: 1))
testPoint2.distanceFrom(testPoint).km


Latitude(degrees: 10)
Longitude(degrees: 195)
let h = Latitude(degrees: 10)
let i = Latitude(degrees: 85)
h
i
(h + i)

(Latitude(degrees: 10) + Latitude(degrees: 85))
Latitude(degrees: 10 + 90)

Length(m: 5) + Length(m: 50)

