import Cocoa

// MARK: Base Protocol
public protocol Unit: CustomStringConvertible, FloatLiteralConvertible {
    var value: Double { get set }
    var baseSymbol: String { get }
    
    init(value: Double)
}

public extension Unit {
    public init(value: Double, prefix: Prefix) {
        self.init(value: value)
        self.value = value * prefix.rawValue
    }
    
    public var description: String {
        return "\(String(format: "%.1f", value))\(baseSymbol)"
    }
    
    public func value(prefix: Prefix) -> Double {
        return value / prefix.rawValue
    }
    
    public func string(prefix: Prefix) -> String {
        return "\(String(format: "%.1f", self.value(prefix)))\(prefix)\(baseSymbol)"
    }
}

public extension Unit {
    static func convertToBase(prefix: Prefix, power: Double, value: Double) -> Double {
        return pow(prefix.rawValue, power) * value
    }
    
    static func convertToPrefix(prefix: Prefix, power: Double, value: Double) -> Double {
        return value / pow(prefix.rawValue, power)
    }
}
/*
extension Unit {
    init(floatLiteral: FloatLiteralType) {
        self.init(Double(floatLiteral))
    }
}
*/

// MARK: Generic Functions
public func * <U: Unit>(lhs: Double, rhs: U) -> U {
    return U(value: lhs * rhs.value)
}
public func * <U: Unit>(lhs: U, rhs: Double) -> U {
    return U(value: lhs.value * rhs)
}

public func / <U: Unit>(lhs: U, rhs: Double) -> U {
    return U(value: lhs.value / rhs)
}

public func + <U: Unit>(lhs: U, rhs: U) -> U {
    return U(value: lhs.value + rhs.value)
}

public func - <U: Unit>(lhs: U, rhs: U) -> U {
    return U(value: lhs.value - rhs.value)
}

// MARK: Prefix System
// Multiplier and Fractions
public enum Prefix: Double {
    case yocto = 1e-24
    case zepto = 1e-21
    case atto  = 1e-18
    case femto = 1e-15
    case pico  = 1e-12
    case nano  = 1e-9
    case micro = 1e-6
    case milli = 1e-3
    case centi = 1e-2
    case deci  = 1e-1
    case unity = 1
    case deca  = 1e1
    case hecto = 1e2
    case kilo  = 1e3
    case mega  = 1e6
    case giga  = 1e9
    case tera  = 1e12
    case peta  = 1e15
    case exa   = 1e18
    case zetta = 1e21
    case yotta = 1e24
}

extension Prefix: CustomStringConvertible {
    public var description: String {
        switch self {
        case .yocto: return "y"
        case .zepto: return "z"
        case .atto:  return "a"
        case .femto: return "f"
        case .pico:  return "p"
        case .nano:  return "n"
        case .micro: return "u"
        case .milli: return "m"
        case .centi: return "c"
        case .deci:  return "d"
        case .unity: return ""
        case .deca:  return "da"
        case .hecto: return "h"
        case .kilo:  return "k"
        case .mega:  return "M"
        case .giga:  return "G"
        case .tera:  return "T"
        case .peta:  return "P"
        case .exa:   return "E"
        case .zetta: return "Z"
        case .yotta: return "Y"
        }
    }
}


// MARK: Specific Units
public struct Mass: Unit {
    public var value: Double
    public let baseSymbol = "kg"
    
    public var g: Double {
        return Prefix.kilo.rawValue * value
    }
    public var kg: Double {
        return  value
    }
    public var tonne: Double {
        return value / Prefix.kilo.rawValue
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(g: Double) {
        self.value = g / Prefix.kilo.rawValue
    }
    public init(kg: Double) {
        self.value = kg
    }
    public init(tonne: Double) {
        self.value = Prefix.kilo.rawValue * tonne
    }
    public init(value: Double, prefix: Prefix) {
        self.value = prefix.rawValue * value / 1000 // To account for kg being the base not gram
    }
}

public struct Volume: Unit {
    public var value: Double
    public let baseSymbol = "m^3"
    let power: Double = 3
    
    public var  m3: Double { return Volume.convertToPrefix(.unity, power: power, value: value) }
    public var cm3: Double { return Volume.convertToPrefix(.centi, power: power, value: value) }
    public var mm3: Double { return Volume.convertToPrefix(.milli, power: power, value: value) }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init( m3: Double) { self.value = m3 }
    public init(cm3: Double) { self.value = Volume.convertToBase(.centi, power: power, value: cm3) }
    public init(mm3: Double) { self.value = Volume.convertToBase(.milli, power: power, value: mm3) }
    
    public init(l: Length, w: Length, d: Length) {
        self.value = (l * w * d).m3
    }
    public init(area: Area, length: Length) {
        self.value = (area * length).m3
    }
}

public struct Area: Unit {
    public var value: Double
    public let baseSymbol = "m^2"
    let power: Double = 2
    
    public var  m2: Double { return value }
    public var mm2: Double { return Area.convertToPrefix(.milli, power: power, value: value) }
    public var cm2: Double { return Area.convertToPrefix(.centi, power: power, value: value) }
    public var km2: Double { return Area.convertToPrefix( .kilo, power: power, value: value) }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    
    public init( m2: Double) { self.value = m2 }
    public init(mm2: Double) { self.value = Area.convertToBase(.milli, power: power, value: mm2) }
    public init(cm2: Double) { self.value = Area.convertToBase(.centi, power: power, value: cm2) }
    public init(km2: Double) { self.value = Area.convertToBase( .kilo, power: power, value: km2) }
}

public struct Length: Unit {
    public var value: Double
    public let baseSymbol = "m"
    
    public var m: Double {
        return value
    }
    public var mm: Double {
        return 1000 * value
    }
    public var cm: Double {
        return 100 * value
    }
    public var km: Double {
        return value / 1000
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    
    public init(value: Double) {
        self.value = value
    }
    public init(m: Double) {
        self.value = m
    }
    public init(mm: Double) {
        self.value = mm / 1000
    }
    public init(cm: Double) {
        self.value = cm / 100
    }
    public init(km: Double) {
        self.value = 1000 * km
    }
}

public struct Velocity: Unit {
    public var value: Double
    public let baseSymbol = "m/s"
    
    public var mps: Double {
        return value
    }
    public var mmps: Double {
        return 1000 * value
    }
    public var kph: Double {
        return 60 * 60 * value / 1000
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(mps: Double) {
        self.value = mps
    }
    public init(mmps: Double) {
        self.value = mmps / 1000
    }
    public init(kph: Double) {
        self.value = 1000 * kph / 60 / 60
    }
}

public struct Acceleration: Unit {
    public var value: Double
    public let baseSymbol = "m/s^2"
    
    public var mps2: Double {
        return value
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(mps2: Double) {
        self.value = mps2
    }
}

public struct Angle: Unit {
    public var value: Double
    public let baseSymbol = "radians"
    
    public var radians: Double {
        return value
    }
    public var degrees: Double {
        return 180 * value / M_PI
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(radians: Double) {
        self.value = radians
    }
    public init(degrees: Double) {
        self.value = M_PI * degrees / 180
    }
}

public struct VolumeFlowRate: Unit {
    public var value: Double
    public let baseSymbol = "m^3/s"
    
    public var m3ps: Double {
        return value
    }
    public var mm3ps: Double {
        return 1000 * 1000 * 1000 * value
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(m3ps: Double) {
        self.value = m3ps
    }
    public init(mm3ps: Double) {
        self.value = mm3ps / 1000 / 1000 / 1000
    }
}

public struct MassFlowRate: Unit {
    public var value: Double
    public let baseSymbol = "kg/s"
    
    public var kgps: Double {
        return value
    }
    public var tph: Double {
        return 60 * 60 * value / 1000
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(kgps: Double) {
        self.value = kgps
    }
    public init(tph: Double) {
        self.value = 1000 * tph / 60 / 60
    }
}

public struct Density: Unit, CustomStringConvertible {
    public var value: Double
    public let baseSymbol = "kg/m^3"
    
    public var tpm3: Double {
        return 1000 * value
    }
    public var kgpm3: Double {
        return value
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    
    public init(tpm3: Double) {
        self.value = tpm3 * 1000
    }
    public init(kgpm3: Double) {
        self.value = kgpm3
    }
    
    public init(mass: Mass, volume: Volume) {
        value = mass.kg * volume.value
    }
}

public struct MassPerLength: Unit {
    public var value: Double
    public let baseSymbol = "kg/m"
    
    public var kgpm: Double {
        return value
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(kgpm: Double) {
        self.value = kgpm
    }
}

public struct Force: Unit {
    public var value: Double
    public let baseSymbol = "N"
    
    public var N: Double {
        return value
    }
    public var kN: Double {
        return value / 1000
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    
    public init(value: Double) {
        self.value = value
    }
    public init(N: Double) {
        self.value = N
    }
    public init(kN: Double) {
        self.value = 1000 * kN
    }
    
    public init(mass: Mass, acceleration: Acceleration) {
        self.value = mass.kg * acceleration.mps2
    }
}

public struct Power: Unit {
    public var value: Double
    public let baseSymbol = "W"
    
    public var W: Double {
        return value
    }
    public var kW: Double {
        return value / 1000
    }
    public var MW: Double {
        return value / 1_000_000
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(W: Double) {
        self.value = W
    }
    public init(kW: Double) {
        self.value = 1000 * kW
    }
    public init(MW: Double) {
        self.value = 1_000_000 * MW
    }
}

public struct Time: Unit {
    public var value: Double
    public let baseSymbol = "s"
    
    public var sec: Double {
        return value
    }
    public var min: Double {
        return value / 60
    }
    public var hr: Double {
        return value / 60 / 60
    }
    public var msec: Double {
        return 1000 * value
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(sec: Double) {
        self.value = sec
    }
    public init(min: Double) {
        self.value = 60 * min
    }
    public init(hr: Double) {
        self.value = 60 * 60 * hr
    }
    public init(msec: Double) {
        self.value = msec / 1000
    }
}


public struct Torque: Unit {
    public var value: Double
    public let baseSymbol = "Nm"
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    
    public var Nm: Double {
        return value
    }
    public var kNm: Double {
        return value / Prefix.kilo.rawValue
    }
    
    public init(Nm: Double) {
        self.value = Nm
    }
    public init(kNm: Double) {
        self.value = Prefix.kilo.rawValue * kNm
    }
}

public struct AngularVelocity: Unit {
    public var value: Double
    public let baseSymbol: String = "rad/s"
    
    public var radps: Double {
        return value
    }
    public var rpm: Double {
        return 2 * 3.14 * value / 60
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(radps: Double) {
        self.value = radps
    }
    public init(rpm: Double) {
        self.value = 60 * rpm / 2 / 3.14
    }
}

// MARK: Electrical

public struct Current: Unit {
    public var value: Double
    public let baseSymbol = "A"
    
    public var A: Double {
        return value
    }
    public var mA: Double {
        return value / Prefix.milli.rawValue
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(A: Double) {
        self.value = A
    }
    public init(mA: Double) {
        self.value = Prefix.milli.rawValue * mA
    }
}

public struct Voltage: Unit {
    public var value: Double
    public let baseSymbol = "V"
    
    public var V: Double {
        return value
    }
    public var mV: Double {
        return value / Prefix.milli.rawValue
    }
    public var kV: Double {
        return  value / Prefix.kilo.rawValue
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(V: Double) {
        self.value = V
    }
    public init(mV: Double) {
        self.value = Prefix.milli.rawValue * mV
    }
    public init(kV: Double) {
        self.value = Prefix.kilo.rawValue * kV
    }
}

// MARK: Computing
public struct FLOP: Unit {
    public var value: Double
    public let baseSymbol = "FLOP"
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    
}

// MARK: Global Coordinates

public struct Latitude: Unit {
    var _value: Double = 0
    public var value: Double {
        set {
            func iter(v: Double) -> Double {
                switch v {
                case let a where a > (M_PI / 2):
                    return iter(a - M_PI)
                case let b where b < -(M_PI / 2):
                    return iter(b + M_PI)
                default:
                    return v
                }
            }
            
            self._value = iter(newValue)
        }
        get {
            return self._value
        }
    }
    public var baseSymbol: String = "φ"
    
    public var radians: Double {
        return value
    }
    public var degrees: Double {
        return 180 * value / M_PI
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(radians: Double) {
        self.value = radians
    }
    public init(degrees: Double) {
        self.value = M_PI * degrees / 180
    }
    
    public var description: String {
        return "\(String(format: "%.6f", self.degrees))\(baseSymbol)"
    }
}

public struct Longitude: Unit {
    var _value: Double = 0
    public var value: Double {
        set {
            func iter(v: Double) -> Double {
                switch v {
                case let a where a > M_PI:
                    return iter(a - (2 * M_PI))
                case let b where b < -M_PI:
                    return iter(b + (2 * M_PI))
                default:
                    return v
                }
            }
            
            self._value = iter(newValue)
        }
        get {
            return self._value
        }
    }
    public var baseSymbol: String = "λ"
    
    public var radians: Double {
        return value
    }
    public var degrees: Double {
        return 180 * value / M_PI
    }
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = Double(floatLiteral)
    }
    public init(value: Double) {
        self.value = value
    }
    public init(radians: Double) {
        self.value = radians
    }
    public init(degrees: Double) {
        self.value = M_PI * degrees / 180
    }
    
    public var description: String {
        return "\(String(format: "%.6f", self.degrees))\(baseSymbol)"
    }
}

public struct Coordinate: CustomStringConvertible {
    public let latitude: Latitude
    public let longitude: Longitude
    
    public let radiusOfEarth = Length(km: 6373)
    
    public init(latitude: Latitude, longitude: Longitude) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func distanceFrom(coordinate: Coordinate) -> Length {
        let(dLat, dLon) = (latitude - coordinate.latitude, longitude - coordinate.longitude)
        let (sqSinLat, sqSinLon) = (pow(sin(dLat.radians / 2.0), 2.0), pow(sin(dLon.radians / 2.0), 2.0))
        let a = sqSinLat + sqSinLon * cos(latitude.radians) * cos(coordinate.latitude.radians)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        return c * radiusOfEarth
    }
    
    public var description: String {
        return "\(latitude) \(longitude)"
    }
}


// MARK: Operators
// MARK: Multiplication
public func * (lhs: Density, rhs: VolumeFlowRate) -> MassFlowRate {
    return MassFlowRate(kgps: lhs.kgpm3 * rhs.m3ps)
}
public func * (lhs: VolumeFlowRate, rhs: Density) -> MassFlowRate {
    return MassFlowRate(kgps: lhs.m3ps * rhs.kgpm3)
}

public func * (lhs: Area, rhs: Velocity) -> VolumeFlowRate {
    return VolumeFlowRate(m3ps: lhs.m2 * rhs.mps)
}
public func * (lhs: Velocity, rhs: Area) -> VolumeFlowRate {
    return VolumeFlowRate(m3ps: rhs.m2 * lhs.mps)
}

public func * (lhs: Length, rhs: Length) -> Area {
    return Area(m2: lhs.m * rhs.m)
}

public func * (lhs: MassPerLength, rhs: Length) -> Mass {
    return Mass(kg: lhs.kgpm * rhs.m)
}
public func * (lhs: Length, rhs: MassPerLength) -> Mass {
    return Mass(kg: lhs.m * rhs.kgpm)
}

// F = ma
public func * (lhs: Mass, rhs: Acceleration) -> Force {
    return Force(N: lhs.kg * rhs.mps2)
}
public func * (lhs: Acceleration, rhs: Mass) -> Force {
    return Force(N: lhs.mps2 * rhs.kg)
}
public func / (lhs: Force, rhs: Mass) -> Acceleration {
    return Acceleration(mps2: lhs.N / rhs.kg)
}
public func / (lhs: Force, rhs: Acceleration) -> Mass {
    return Mass(kg: lhs.N / rhs.mps2)
}

public func * (lhs: Force, rhs: Velocity) -> Power {
    return Power(W: lhs.N * rhs.mps)
}
public func * (lhs: Velocity, rhs: Force) -> Power {
    return Power(W: lhs.mps * rhs.N)
}

public func * (lhs:Length, rhs: Force) -> Torque {
    return Torque(value: lhs.m * rhs.N)
}
public func * (lhs:Force, rhs: Length) -> Torque {
    return Torque(value: rhs.m * lhs.N)
}

public func * (lhs: Torque, rhs: AngularVelocity) -> Power {
    return Power(W: lhs.Nm * rhs.radps)
}
public func * (lhs: AngularVelocity, rhs: Torque) -> Power {
    return Power(W: lhs.radps * rhs.Nm)
}

public func * (lhs: Area, rhs: Length) -> Volume {
    return Volume(value: lhs.m2 * rhs.m)
}
public func * (lhs: Length, rhs: Area) -> Volume {
    return Volume(value: lhs.m * rhs.m2)
}

public func * (lhs: Voltage, rhs: Current) -> Power {
    return Power(W: lhs.V * rhs.A)
}
public func * (lhs: Current, rhs: Voltage) -> Power {
    return Power(W: lhs.A * rhs.V)
}

// MARK: Division
public func / (lhs: MassFlowRate, rhs: Velocity) -> MassPerLength {
    return MassPerLength(kgpm: lhs.kgps / rhs.mps)
}
public func / (lhs: Mass, rhs: Volume) -> Density {
    return Density(kgpm3: lhs.kg / rhs.m3)
}
public func / (lhs: Power, rhs: AngularVelocity) -> Torque {
    return Torque(Nm: lhs.W / rhs.radps)
}
public func / (lhs: Torque, rhs: Length) -> Force {
    return Force(N: lhs.Nm / rhs.m)
}


// MARK: Common Constants
public let gravity = Acceleration(mps2: 9.81)


