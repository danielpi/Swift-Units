# Swift Units
A framework for working with Dimensions and Units in Swift.

I'm an engineer and I do a lot of calculations. I also make a lot of mistakes. I use the wrong value, I use the wrong equation, I get my rpm and m/s mixed up and I use degrees where I should use radians. 

When I was working with pen and paper at Uni I got in the habit of writing out the units of my calculations in a column beside the formulas and figures. This allowed me to double check that the figures I were getting made sense. Since switching to spreadsheets I still keep track of the units in a column but that can be a bit cumbersome and I still make a bunch of mistakes. 

I've been learning Swift lately and one of the nicest features of the language is the type system. It does the boring job of making sure that I am at least using the right types of data for all of my computations. This got me thinking... Why don't I use Swift's type system to keep track of the units of my calculations?

Turns out heaps of others have already tried this. Here are some examples
- units in Haskell, <https://github.com/goldfirere/units>
- Units of Measure in F#, <http://research.microsoft.com/en-us/um/people/akenn/units/index.html>

I also shouldn't forget about significant digits (precision) and measurement uncertainty (e.g., 5 +- 0.2 meters) 
- http://hep.physics.indiana.edu/~rickv/Quantities.html
- http://www.roboticsengineeringcte502.com/blog---computational-scientist/why-computing-with-measured-quantities-is-hard

Grab the playground and try it out.