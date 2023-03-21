# FCS2yearproject
Working with the surrounding reality, people use dynamic systems of the form:
𝑥′ = 𝑓 (𝑥)
where x is a vector (of coordinates, momenta, concentrations, whatever). From the point of view of
calculations, there are several levels of "convenience"of the function f (x), which defines the dynamics:
1. just any functions (well, which can be written with a reasonable formula)
2. rational functions (that is, polynomial relations)
3. polynomials
4. polynomials of degree at most 2
Depending on the specific situation, it can be very useful to "embed"a system into a system with
a higher level of goodness. polynomialization is a transformation of a system of ODEs into a system
of ODEs with polynomial right-hand via the introduction of new variables. Such transformations have
been used, for example, as a preprocessing step by model order reduction methods and for transforming
chemical reaction networks. As a result, we should get an algorithm that, for a given system of ODEs,
finds a transformation into a polynomial ODE system by introducing new variables 𝑧𝑖(𝑥), which will just
create a new ODE system. The algorithm will produce a transformation of this form, which will reduce
the number of new variables as much as possible.
