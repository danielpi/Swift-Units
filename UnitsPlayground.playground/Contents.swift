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


// How fast would that force accelerate a 100 gram load

let acceleration = force / Mass(g: 100)

let v = Volume(cm3: 12000000000)
v.cm3
v.m3

